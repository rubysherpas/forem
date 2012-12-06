module Forem
  class TopicsController < Forem::ApplicationController
    helper 'forem/posts'
    before_filter :authenticate_forem_user, :except => [:show]
    before_filter :find_forum
    before_filter :find_topic, :only => [:show, :subscribe, :unsubscribe]
    before_filter :block_spammers, :only => [:new, :create]

    def show
      register_view
      @posts = @topic.posts
      unless forem_admin_or_moderator?(@forum)
        @posts = @posts.approved_or_pending_review_for(forem_user)
      end
      @posts = @posts.page(params[:page]).per(Forem.per_page)
    end

    def new
      authorize! :create_topic, @forum
      @topic = @forum.topics.build
      @topic.posts.build
    end

    def create
      authorize! :create_topic, @forum
      @topic      = @forum.topics.build(params[:topic], :as => :default)
      @topic.user = forem_user
      if @topic.save
        flash[:notice] = t("forem.topic.created")
        redirect_to [@forum, @topic]
      else
        flash.now.alert = t("forem.topic.not_created")
        render :action => "new"
      end
    end

    def destroy
      @topic = @forum.topics.find(params[:id])
      if forem_user == @topic.user || forem_user.forem_admin?
        @topic.destroy
        flash[:notice] = t("forem.topic.deleted")
      else
        flash.alert = t("forem.topic.cannot_delete")
      end

      redirect_to @topic.forum
    end

    def subscribe
      @topic.subscribe_user(forem_user.id)
      flash[:notice] = t("forem.topic.subscribed")
      redirect_to forum_topic_url(@topic.forum, @topic)
    end

    def unsubscribe
      @topic.unsubscribe_user(forem_user.id)
      flash[:notice] = t("forem.topic.unsubscribed")
      redirect_to forum_topic_url(@topic.forum, @topic)
    end

    private
    def find_forum
      @forum = Forem::Forum.find(params[:forum_id])
      authorize! :read, @forum
    end

    def find_topic
      scope = @forum.topics
      unless forem_admin_or_moderator?(@forum)
        scope = scope.visible.approved_or_pending_review_for(forem_user)
      end
      @topic = scope.find(params[:id])
      authorize! :read, @topic
      unless @forum.slug == params[:forum_id] && @topic.slug == params[:id]
        redirect_to forum_topic_url(@forum, @topic), :status => 301
      end
    rescue ActiveRecord::RecordNotFound
      # Todo: We are responding with 301 to pages that should be 404
      # This probably isn't right
      redirect_to @forum, :alert => t("forem.topic.not_found")
    end

    def register_view
      @topic.register_view_by(forem_user)
    end

    def block_spammers
      if forem_user.forem_state == "spam"
        flash[:alert] = t('forem.general.flagged_for_spam') + ' ' + t('forem.general.cannot_create_topic')
        redirect_to :back
      end
    end
  end
end
