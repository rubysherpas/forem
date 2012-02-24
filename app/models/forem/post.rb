module Forem
  class Post < ActiveRecord::Base
    # Used in the moderation tools partial
    attr_accessor :moderation_option

    belongs_to :topic
    belongs_to :user, :class_name => Forem.user_class.to_s
    belongs_to :reply_to, :class_name => "Post"

    has_many :replies, :class_name => "Post",
                       :foreign_key => "reply_to_id",
                       :dependent => :nullify

    delegate :forum, :to => :topic

    class << self
      def by_created_at
        order("created_at asc")
      end

      def pending_review
        where(:pending_review => true)
      end

      def approved
        where(:pending_review => false)
      end

      def approved_or_pending_review_for(user)
        if user
          where("(forem_posts.pending_review = ?) OR " +
                 "(forem_posts.pending_review = ? AND forem_posts.user_id = ?)",
                 false, true, user.id)
        else
          approved
        end
      end

      def topic_not_pending_review
        joins(:topic).where("forem_topics.pending_review" => false)
      end

      def moderate!(posts)
        posts.each do |post_id, moderation|
          # We use find_by_id here just in case a post has been deleted.
          post = Post.find_by_id(post_id)
          post.send("#{moderation[:moderation_option]}!") if post
        end
      end
    end

    validates :text, :presence => true
    after_create :subscribe_replier
    after_create :email_topic_subscribers

    def owner_or_admin?(other_user)
      self.user == other_user || other_user.forem_admin?
    end

    def approved?
      !pending_review?
    end

    def approve!
      update_attribute(:pending_review, false)
    end

    def subscribe_replier
      if self.topic && self.user
        self.topic.subscribe_user(self.user.id)
      end
    end

    def email_topic_subscribers
      if self.topic
        self.topic.subscriptions.includes(:subscriber).each do |subscription|
          if subscription.subscriber != self.user
            subscription.send_notification(self.id)
          end
        end
      end
    end
  end
end
