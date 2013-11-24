module Forem
  class TopicsController < Forem::ApplicationController
    helper 'forem/posts'
    before_filter :authenticate_forem_user, :except => [:show]
    before_filter :find_forum
    before_filter :block_spammers, :only => [:new, :create]

    def show
      if find_topic
        register_view(@topic, forem_user)
        @posts = find_posts(@topic)

        # Kaminari allows to configure the method and param used
        @posts = @posts.send(pagination_method, params[pagination_param]).per(Forem.per_page)
      end
    end

    def new
      authorize! :create_topic, @forum
      @topic = @forum.topics.build
      @topic.posts.build
    end

    def create
      authorize! :create_topic, @forum
      @topic = @forum.topics.build(topic_params)
      @topic.user = forem_user
      if @topic.save
        create_successful
      else
        create_unsuccessful
      end
    end

    def destroy
      @topic = @forum.topics.friendly.find(params[:id])
      if forem_user == @topic.user || forem_user.forem_admin?
        @topic.destroy
        destroy_successful
      else
        destroy_unsuccessful
      end
    end

    def subscribe
      if find_topic
        @topic.subscribe_user(forem_user.id)
        subscribe_successful
      end
    end

    def unsubscribe
      if find_topic
        @topic.unsubscribe_user(forem_user.id)
        unsubscribe_successful
      end
    end

    protected

    def topic_params
      params.require(:topic).permit(:subject, :posts_attributes => [[:text]])
    end
    
    def create_successful
      redirect_to [@forum, @topic], :notice => t("forem.topic.created")
    end

    def create_unsuccessful
      flash.now.alert = t('forem.topic.not_created')
      render :action => 'new'
    end

    def destroy_successful
      flash[:notice] = t("forem.topic.deleted")

      redirect_to @topic.forum
    end

    def destroy_unsuccessful
      flash.alert = t("forem.topic.cannot_delete")

      redirect_to @topic.forum
    end

    def subscribe_successful
      flash[:notice] = t("forem.topic.subscribed")
      redirect_to forum_topic_url(@topic.forum, @topic)
    end

    def unsubscribe_successful
      flash[:notice] = t("forem.topic.unsubscribed")
      redirect_to forum_topic_url(@topic.forum, @topic)
    end

    private
    def find_forum
      @forum = Forem::Forum.friendly.find(params[:forum_id])
      authorize! :read, @forum
    end

    def find_posts(topic)
      posts = topic.posts
      unless forem_admin_or_moderator?(topic.forum)
        posts = posts.approved_or_pending_review_for(forem_user)
      end
      @posts = posts
    end

    def find_topic
      begin
        @topic = forum_topics(@forum, forem_user).friendly.find(params[:id])
        authorize! :read, @topic
      rescue ActiveRecord::RecordNotFound
        flash.alert = t("forem.topic.not_found")
        redirect_to @forum and return
      end
    end

    def register_view(topic, user)
      topic.register_view_by(user)
    end

    def block_spammers
      if forem_user.forem_spammer?
        flash[:alert] = t('forem.general.flagged_for_spam') + ' ' +
                        t('forem.general.cannot_create_topic')
        redirect_to :back
      end
    end

    def forum_topics(forum, user)
      if forem_admin_or_moderator?(forum)
        forum.topics
      else
        forum.topics.visible.approved_or_pending_review_for(user)
      end
    end
  end
end
