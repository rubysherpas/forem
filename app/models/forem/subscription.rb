module Forem
  class Subscription < ActiveRecord::Base
    belongs_to :topic
    belongs_to :subscriber, :class_name => Forem.user_class.to_s

    validates :subscriber_id, :presence => true

    before_create :set_token

    def send_notification(post_id)
      # If a user cannot be found, then no-op
      # This will happen if the user record has been deleted.
      if subscriber.present?
        SubscriptionMailer.topic_reply(post_id, subscriber.id).deliver
      end
    end

    private

    def set_token
      self.token = SecureRandom.hex(24)
    end
  end
end
