module Forem
  module Admin
    class NotificationsController < BaseController

      def index
        @categories = Forem::Category.all
      end

      def subscribe
        topic = Forem::Topic.find(params[:topic_id])
        topic.subscribe_user(params[:user_id])
        render :nothing => true
      end

      def unsubscribe
        topic = Forem::Topic.find(params[:topic_id])
        topic.unsubscribe_user(params[:user_id])
        render :nothing => true
      end

      def auto_subscribe
        admin = Forem.user_class.find(params[:user_id])
        admin.forem_auto_subscribe = true
        admin.save
        render :nothing => true
      end

      def auto_unsubscribe
        admin = Forem.user_class.find(params[:user_id])
        admin.forem_auto_subscribe = false
        admin.save
        render :nothing => true
      end
    end
  end
end
