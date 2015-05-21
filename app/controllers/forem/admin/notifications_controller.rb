module Forem
  module Admin
    class NotificationsController < BaseController

      def auto_subscribe
        admin = find_admin
        admin.update_attribute(:forem_auto_subscribe, true)
        render :nothing => true
      end

      def auto_unsubscribe
        admin = find_admin
        admin.update_attribute(:forem_auto_subscribe, false)
        render :nothing => true
      end

      def category_subscribe
        admin = find_admin
        category = Forem::Category.find(params[:category_id])

        category.forums.each do |forum|
          forum.topics.each do |topic|
            unless topic.subscriptions.exists?(subscriber_id: admin.id)
              topic.subscribe_user(admin.id)
            end
          end
        end

        category.subscribe_user(params[:user_id])
        render :nothing => true
      end

      def category_unsubscribe
        admin = find_admin
        category = Forem::Category.find(params[:category_id])

        category.forums.each do |forum|
          forum.topics.each do |topic|
            if topic.subscriptions.exists?(subscriber_id: admin.id)
              topic.unsubscribe_user(admin.id)
            end
          end
        end

        category.unsubscribe_user(params[:user_id])
        render :nothing => true
      end

      def index
        @categories = Forem::Category.all
      end

      def topic_subscribe
        topic = Forem::Topic.find(params[:topic_id])
        topic.subscribe_user(params[:user_id])
        render :nothing => true
      end

      def topic_unsubscribe
        topic = Forem::Topic.find(params[:topic_id])
        topic.unsubscribe_user(params[:user_id])
        render :nothing => true
      end

      private

      def find_admin
        Forem.user_class.find(params[:user_id])
      end
    end
  end
end
