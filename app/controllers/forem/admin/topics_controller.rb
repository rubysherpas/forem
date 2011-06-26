module Forem
  module Admin
    class TopicsController < BaseController
      before_filter :find_topic

      def edit
      end

      def update
        @topic.subject = params[:topic][:subject]
        @topic.pinned  = params[:topic][:pinned]
        @topic.locked  = params[:topic][:locked]
        @topic.hidden  = params[:topic][:hidden]
        if @topic.save
          flash[:notice] = t("forem.topic.updated")
          redirect_to forum_topic_path(@topic.forum, @topic)
        else
          flash[:error] = t("forem.topic.not_updated")
          render :action => "edit"
        end
      end

      def destroy
        forum = @topic.forum
        @topic.destroy
        flash[:notice] = t("forem.topic.deleted")
        redirect_to forum_topics_path(forum)
      end

      def toggle_hide
        @topic.toggle!(:hidden)
        i18n_string = @topic.hidden? ? "hidden" : "visible"
        flash[:notice] = t("forem.topic.#{i18n_string}")
        redirect_to forum_topic_path(@topic.forum, @topic)
      end

      private
        def find_topic
          @topic = Forem::Topic.find(params[:id])
        end
    end
  end
end
