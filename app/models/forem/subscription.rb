module Forem
  class Subscription < ActiveRecord::Base
    belongs_to :topic
    belongs_to :subscriber, :class_name => Forem.user_class.to_s
    validates_presence_of :subscriber_id

    def send_notification(post)
      SubscriptionMailer.topic_reply(post, self.subscriber).deliver
    end
  end
end
