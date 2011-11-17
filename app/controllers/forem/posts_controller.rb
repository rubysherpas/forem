module Forem
  class PostsController < Forem::ApplicationController
    before_filter :authenticate_forem_user
    before_filter :find_topic

    def new
      @post = @topic.posts.build
      if params[:quote]
        @reply_to = @topic.posts.find(params[:reply_to_id])
      end
    end

    def create
      if @topic.locked?
        flash.alert = t("forem.post.not_created_topic_locked")
        redirect_to [@topic.forum, @topic] and return
      end
      @post = @topic.posts.build(params[:post])
      @post.user = forem_user
      if @post.save
        flash[:notice] = t("forem.post.created")
        redirect_to [@topic.forum, @topic]
      else
        params[:reply_to_id] = params[:post][:reply_to_id]
        flash.now.alert = t("forem.post.not_created")
        render :action => "new"
      end
    end

    def destroy
      @post = @topic.posts.find(params[:id])
      if @post.owner_or_admin?(forem_user)
        @post.destroy
        if @post.topic.posts.count == 0
          @post.topic.destroy
          flash[:notice] = t("forem.post.deleted_with_topic")
          redirect_to [@topic.forum]
        else
          flash[:notice] = t("forem.post.deleted")
          redirect_to [@topic.forum, @topic]
        end
      else
        flash[:alert] = t("forem.post.cannot_delete")
        redirect_to [@topic.forum, @topic]
      end

    end

    private

    def find_topic
      @topic = Forem::Topic.find(params[:topic_id])
    end
  end
end
