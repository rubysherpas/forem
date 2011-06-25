module Forem
  module Admin
    class TopicsController < BaseController
      before_filter :find_topic, :only => [:edit, :update, :destroy]

      def edit
      end

      def update
        @topic.subject = params[:topic][:subject]
        @topic.pinned  = params[:topic][:pinned]
        @topic.locked  = params[:topic][:locked]
        @topic.hidden  = params[:topic][:hidden]
        if @topic.save
          flash[:notice] = t("forem.admin.topic.updated")
          redirect_to forum_topic_path(@topic.forum, @topic)
        else
          flash[:error] = t("forem.admin.topic.not_updated")
          render :action => "edit"
        end
      end

      def destroy
        forum = @topic.forum
        @topic.destroy
        flash[:notice] = t("forem.admin.topic.deleted")
        redirect_to forum_topics_path(forum)
      end

      private
        def find_topic
          @topic = Forem::Topic.find(params[:id])
        end
    end
  end
end
