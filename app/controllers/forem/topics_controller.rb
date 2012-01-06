module Forem
  class TopicsController < Forem::ApplicationController
    helper 'forem/posts'
    before_filter :authenticate_forem_user, :except => [:show]
    before_filter :find_forum, :except => [:subscribe, :unsubscribe]

    def show
      begin
        scope = forem_admin? ? @forum.topics : @forum.topics.visible
        @topic = scope.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash.alert = t("forem.topic.not_found")
        redirect_to @forum
      else
        register_view
        @posts = @topic.posts.page(params[:page]).per(20)
      end
    end

    def new
      authorize! :create_topic, @forum
      @topic = @forum.topics.build
      @topic.posts.build
    end

    def create
      authorize! :create_topic, @forum
      @topic = @forum.topics.build(params[:topic])
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
      @topic = Topic.find(params[:id])
      authorize! :read, @topic
      @topic.subscribe_user(forem_user.id)
			flash[:notice] = t("forem.topic.subscribed")
      redirect_to forum_topic_url(@topic.forum, @topic)
    end

    def unsubscribe
      @topic = Topic.find(params[:id])
      authorize! :read, @topic
      @topic.unsubscribe_user(forem_user.id)
			flash[:notice] = t("forem.topic.unsubscribed")
      redirect_to forum_topic_url(@topic.forum, @topic)
    end

    private
    def find_forum
      @forum = Forem::Forum.find(params[:forum_id])
      authorize! :read, @forum
    end

    def register_view
      @topic.register_view_by(forem_user)
    end
  end
end
