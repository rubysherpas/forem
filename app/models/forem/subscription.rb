module Forem
  class Subscription < ActiveRecord::Base
    belongs_to :topic
    belongs_to :subscriber, :class_name => Forem.user_class.to_s

    validates :subscriber_id, :presence => true

    def send_post_notification(post_id)
      # If a user cannot be found, then no-op
      # This will happen if the user record has been deleted.
      if subscriber.present?

        post = Post.find(post_id)
        user = Forem.user_class.find(subscriber_id)
        opts = {
          forum_id: post.topic.forum_id,
          post: post.id,
          topic: post.topic.id,
          email: user.email
        }
        EmailWorker.perform_async :forum_post_send_to_subscriber, opts
      end
    end
  end
end
