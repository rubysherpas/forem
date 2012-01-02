module Forem
  class Subscription < ActiveRecord::Base
    belongs_to :topic
    belongs_to :subscriber, :class_name => Forem.user_class.to_s
    validates_presence_of :subscriber_id

		def send_notification post_id
			SubscriptionMailer.topic_reply(post_id, self.subscriber.id).deliver
		end
  end
end
