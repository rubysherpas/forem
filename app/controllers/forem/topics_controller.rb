module Forem
  class TopicsController < Forem::ApplicationController
    helper 'forem/posts'
    before_filter :authenticate_forem_user, :except => [:show]
    before_filter :find_forum

    def show
      begin
        scope = forem_admin? ? @forum.topics : @forum.topics.visible
        @topic = scope.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:error] = t("forem.topic.not_found")
        redirect_to @forum
      else
        register_view
        @posts = @topic.posts.page(params[:page]).per(20)
      end
    end

    def new
      @topic = @forum.topics.build
      @topic.posts.build
    end

    def create
      @topic = @forum.topics.build(params[:topic])
      @topic.user = forem_user
      if @topic.save
        flash[:notice] = t("forem.topic.created")
        redirect_to [@forum, @topic]
      else
        flash[:error] = t("forem.topic.not_created")
        render :action => "new"
      end
    end

    def destroy
      @topic = @forum.topics.find(params[:id])
      if forem_user == @topic.user
        @topic.destroy
        flash[:notice] = t("forem.topic.deleted")
      else
        flash[:error] = t("forem.topic.cannot_delete")
      end

      redirect_to @topic.forum
    end

    private
    def find_forum
      @forum = Forem::Forum.find(params[:forum_id])
    end

    def register_view
      @topic.register_view_by(forem_user)
    end
  end
end
