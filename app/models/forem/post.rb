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
      state :approved do
        event :approve, :transitions_to => :approved
      end
    end

    # Used in the moderation tools partial
    attr_accessor :moderation_option

    attr_accessible :text, :reply_to_id

    belongs_to :topic,    :counter_cache => true
    belongs_to :user,     :class_name => Forem.user_class.to_s
    belongs_to :reply_to, :class_name => "Post"

    has_many :replies, :class_name  => "Post",
                       :foreign_key => "reply_to_id",
                       :dependent   => :nullify

    validates :text, :presence => true

    delegate :forum, :to => :topic

    after_create :set_topic_last_post_at
    after_create :subscribe_replier, :if => :user_auto_subscribe?
    after_create :skip_pending_review

    after_save :approve_user,   :if => :approved?
    after_save :blacklist_user, :if => :spam?
    after_save :email_topic_subscribers, :if => Proc.new { |p| p.approved? && !p.notified? }

    class << self
      def approved
        where(:state => "approved")
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
        joins(:topic).where(:forem_topics => { :hidden => false })
      end

      def topic_not_pending_review
        joins(:topic).where(:forem_topics => { :state => 'approved'})
      end

      def moderate!(posts)
        posts.each do |post_id, moderation|
          # We use find_by_id here just in case a post has been deleted.
          post = Post.find_by_id(post_id)
          post.send("#{moderation[:moderation_option]}!") if post
        end
      end
    end

    def user_auto_subscribe?
      user && user.respond_to?(:forem_auto_subscribe) && user.forem_auto_subscribe?
    end

    def owner_or_admin?(other_user)
      user == other_user || other_user.forem_admin?
    end

    protected

    def subscribe_replier
      if topic && user
        topic.subscribe_user(user.id)
      end
    end

    def email_topic_subscribers
      topic.subscriptions.includes(:subscriber).find_each do |subscription|
        if subscription.subscriber != user
          subscription.send_notification(id)
        end
      end
      update_attribute(:notified, true)
    end

    def set_topic_last_post_at
      topic.update_attribute(:last_post_at, created_at)
    end

    def skip_pending_review
      if user.try(:forem_needs_moderation?)
        update_attribute(:state, 'approved')
      end
    end

    def approve_user
      user.update_attribute(:forem_state, "approved") if user && user.forem_state != "approved"
    end

    def blacklist_user
      user.update_attribute(:forem_state, "spam") if user
    end

  end
end
