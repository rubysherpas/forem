module Forem
  class Post < ActiveRecord::Base
    belongs_to :topic, :touch => true
    belongs_to :user, :class_name => Forem.user_class.to_s
    belongs_to :reply_to, :class_name => "Post"

    has_many :replies, :class_name => "Post",
                       :foreign_key => "reply_to_id",
                       :dependent => :nullify

    delegate :forum, :to => :topic

    validates :text, :presence => true
    after_create :subscribe_replier
    after_create :email_topic_subscribers
    after_create :set_topic_last_post_at

    class << self
      def by_created_at
        order("created_at asc")
      end
    end

    def owner_or_admin?(other_user)
      self.user == other_user || other_user.forem_admin?
    end

    private

    def subscribe_replier
      topic.subscribe_user(user.id)
    end

    def email_topic_subscribers
      topic.subscriptions.includes(:subscriber).each do |subscription|
        if subscription.subscriber != user
          subscription.send_notification(id)
        end
      end
    end

    def set_topic_last_post_at
      self.topic.last_post_at = Time.now
    end
  end
end
