module Forem
  class TopicsController < Forem::ApplicationController
    before_filter :authenticate_forem_user, :except => [:show]
    before_filter :find_forum

    def show
      @topic = @forum.topics.find(params[:id])
    end

    def new
      @topic = @forum.topics.build
      @topic.posts.build
    end
  
    def create
      # Association builders are broken in edge Rails atm
      # Hack our way around it
      # TODO: Fix the hack
      @topic = Forem::Topic.new(params[:topic])
      @topic.user = current_user
      @topic.forum_id = params[:forum_id]
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
      if current_user == @topic.user
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
  end
end