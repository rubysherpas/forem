module Forem
  class Subscription < ActiveRecord::Base
    belongs_to :topic
    belongs_to :subscriber, :class_name => Forem.user_class.to_s

    validates :subscriber_id, :presence => true

    def send_notification(post_id)
      # If a user cannot be found, then no-op
      # This will happen if the user record has been deleted.
      if subscriber.present?
        mail = SubscriptionMailer.topic_reply(post_id, subscriber.id)
        if mail.respond_to?(:deliver_later)
          mail.deliver_later
        else
          mail.deliver
        end
      end
    end
  end
end
