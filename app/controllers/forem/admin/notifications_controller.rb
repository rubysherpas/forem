module Forem
  module Admin
    class NotificationsController < BaseController
      def index
        @forums = Forem::Forum.all
      end
      def subscribe
        @topic = Forem::Topic.find(params[:topic_id])
        @topic.subscribe_user(params[:user_id])
        render :nothing => true
      end
      def unsubscribe
        @topic = Forem::Topic.find(params[:topic_id])
        @topic.unsubscribe_user(params[:user_id])
        render :nothing => true
      end
    end
  end
end
