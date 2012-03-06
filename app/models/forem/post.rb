module Forem
  class Post < ActiveRecord::Base
    include Workflow
    workflow_column :state
    workflow do
      state :pending_review do
        event :spam, :transitions_to => :spam
        event :approve, :transitions_to => :approved
      end
      state :spam
      state :approved
    end

    # Used in the moderation tools partial
    attr_accessor :moderation_option

    belongs_to :topic
    belongs_to :user, :class_name => Forem.user_class.to_s
    belongs_to :reply_to, :class_name => "Post"

    has_many :replies, :class_name => "Post",
                       :foreign_key => "reply_to_id",
                       :dependent => :nullify

    delegate :forum, :to => :topic

    validates :text, :presence => true

    after_save :email_topic_subscribers, :if => Proc.new { |p| p.approved? && !p.notified? }

    after_create :set_topic_last_post_at
    after_create :subscribe_replier
    after_create :skip_pending_review_if_user_approved

    after_save :approve_user, :if => :approved?
    after_save :blacklist_user, :if => :spam?


    class << self
      def by_created_at
        order("created_at asc")
      end

      def pending_review
        where(:state => 'pending_review')
      end

      def approved
        where(:state => 'approved').where(:forem_topics => { :state => 'approved' })
      end

      def spam
        where(:state => 'spam')
      end

      def approved_or_pending_review_for(user)
        if user
          where("(forem_posts.state = ?) OR " +
                 "(forem_posts.state = ? AND forem_posts.user_id = ?)",
                 'approved', 'pending_review', user.id)
        else
          approved
        end
      end

      def topic_not_pending_review
        joins(:topic).where("forem_topics.state" => 'approved')
      end

      def moderate!(posts)
        posts.each do |post_id, moderation|
          # We use find_by_id here just in case a post has been deleted.
          post = Post.find_by_id(post_id)
          post.send("#{moderation[:moderation_option]}!") if post
        end
      end
    end

    def owner_or_admin?(other_user)
      self.user == other_user || other_user.forem_admin?
    end

    def approved?
      state == 'approved'
    end

    protected

    def subscribe_replier
      if self.topic && self.user
        self.topic.subscribe_user(self.user.id)
      end
    end

    def email_topic_subscribers
      topic.subscriptions.includes(:subscriber).find_each do |subscription|
        if subscription.subscriber != user
          subscription.send_notification(self.id)
        end
      end
      self.update_attribute(:notified, true)
    end

    def subscribe_replier
      topic.subscribe_user(user.id)
    end

    def set_topic_last_post_at
      self.topic.last_post_at = self.created_at
    end

    def skip_pending_review_if_user_approved
      self.update_attribute(:state, 'approved') if user && user.forem_state == 'approved'
    end

    def approve_user
      user.update_attribute(:forem_state, "approved") if user && user.forem_state != "approved"
    end

    def blacklist_user
      user.update_attribute(:forem_state, "spam") if user
    end

  end
end
