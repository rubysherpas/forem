module Forem
  class Post < ActiveRecord::Base
    include Workflow

    workflow_column :state
    workflow do
      state :pending_review do
        event :spam,    :transitions_to => :spam
        event :approve, :transitions_to => :approved
      end
      state :spam
      state :approved
    end

    # Used in the moderation tools partial
    attr_accessor :moderation_option

    belongs_to :topic
    belongs_to :user,     :class_name => Forem.user_class.to_s
    belongs_to :reply_to, :class_name => "Post"

    has_many :replies, :class_name  => "Post",
                       :foreign_key => "reply_to_id",
                       :dependent   => :nullify

    validates :text, :presence => true

    delegate :forum, :to => :topic

    after_create :set_topic_last_post_at
    after_create :subscribe_replier
    after_create :skip_pending_review_if_user_approved

    after_save :approve_user,   :if => :approved?
    after_save :blacklist_user, :if => :spam?
    after_save :email_topic_subscribers, :if => Proc.new { |p| p.approved? && !p.notified? }

    class << self
      def approved
        includes(:topic).
        select("#{quoted_table_name}.*").
        select(Topic.arel_table[:state].eq('approved'))
      end

      def approved_or_pending_review_for(user)
        if user
          where arel_table[:state].eq('approved').or(
                  arel_table[:state].eq('pending_review').and(arel_table[:user_id].eq(user.id))
                )
        else
          approved
        end
      end

      def by_created_at
        order :created_at
      end

      def pending_review
        where :state => 'pending_review'
      end

      def spam
        where :state => 'spam'
      end

      def visible
        joins(:topic).where Topic.arel_table[:hidden].eq(false)
      end

      def topic_not_pending_review
        joins(:topic).where Topic.arel_table[:state].eq('approved')
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
      self.topic.update_attribute(:last_post_at, self.created_at)
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
