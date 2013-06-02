module Forem
  class ModerationQueueMailer < ActionMailer::Base
    default :from => Forem.email_from_address

    def new_topic(topic)
      @topic = topic
      
      @admin_users = Forem.user_class.find_all_by_forem_admin(true)
      mail(:to => @admin_users.map(&:email), :subject => I18n.t('forem.topic.moderation_needed'))
    end

    def new_post(post)
      @post = post
      
      @admin_users = Forem.user_class.find_all_by_forem_admin(true)
      mail(:to => @admin_users.map(&:email), :subject => I18n.t('forem.post.moderation_needed'))
    end
  end
end

