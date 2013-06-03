module Forem
  class ModerationQueueMailer < ActionMailer::Base
    default :from => Forem.email_from_address

    def new_topic(topic)
      @topic = topic
      mail(:to => admin_users.map(&:email), :subject => I18n.t('forem.topic.moderation_needed'))
    end

    def new_post(post)
      @post = post
      mail(:to => admin_users.map(&:email), :subject => I18n.t('forem.post.moderation_needed'))
    end

    private

    def admin_users
      Forem.user_class.find_all_by_forem_admin(true)
    end
  end
end

