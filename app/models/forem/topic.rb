require 'friendly_id'

module Forem
  class Topic < ActiveRecord::Base
    include Forem::Concerns::Viewable
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

    attr_accessor :moderation_option

    extend FriendlyId
    friendly_id :subject, :use => :slugged

    attr_accessible :subject, :posts_attributes
    attr_accessible :subject, :posts_attributes, :pinned, :locked, :hidden, :forum_id, :as => :admin

    belongs_to :forum
    belongs_to :user, :class_name => Forem.user_class.to_s
    has_many   :subscriptions, :dependent => :destroy
    has_many   :posts, :dependent => :destroy, :order => "forem_posts.created_at ASC"

    accepts_nested_attributes_for :posts

    validates :subject, :presence => true

    before_save  :set_first_post_user
    after_save   :approve_user_and_posts, :if => :approved?
    after_create :subscribe_poster
    after_create :skip_pending_review

    class << self
      def visible
        where(:hidden => false)
      end

      def by_pinned
        order('forem_topics.pinned DESC').
        order('forem_topics.id')
      end

      def by_most_recent_post
        order('forem_topics.last_post_at DESC').
        order('forem_topics.id')
      end

      def by_pinned_or_most_recent_post
        order('forem_topics.pinned DESC').
        order('forem_topics.last_post_at DESC').
        order('forem_topics.id')
      end

      def pending_review
        where(:state => 'pending_review')
      end

      def approved
        where(:state => 'approved')
      end

      def approved_or_pending_review_for(user)
        if user
          where("forem_topics.state = ? OR " +
                "(forem_topics.state = ? AND forem_topics.user_id = ?)",
                 'approved', 'pending_review', user.id)
        else
          approved
        end
      end
    end

    def to_s
      subject
    end

    # Cannot use method name lock! because it's reserved by AR::Base
    def lock_topic!
      update_attribute(:locked, true)
    end

    def unlock_topic!
      update_attribute(:locked, false)
    end

    # Provide convenience methods for pinning, unpinning a topic
    def pin!
      update_attribute(:pinned, true)
    end

    def unpin!
      update_attribute(:pinned, false)
    end

    def moderate!(option)
      send("#{option}!")
    end

    # A Topic cannot be replied to if it's locked.
    def can_be_replied_to?
      !locked?
    end

    def subscribe_poster
      subscribe_user(user_id)
    end

    def subscribe_user(user_id)
      if user_id && !subscriber?(user_id)
        subscriptions.create!(:subscriber_id => user_id)
      end
    end

    def unsubscribe_user(user_id)
      subscriptions.where(:subscriber_id => user_id).destroy_all
    end

    def subscriber?(user_id)
      subscriptions.exists?(:subscriber_id => user_id)
    end

    def subscription_for(user_id)
      subscriptions.where(:subscriber_id => user_id).first
    end

    def last_page
      (self.posts.count.to_f / Forem.per_page.to_f).ceil
    end

    protected
    def set_first_post_user
      post = posts.first
      post.user = user
    end

    def skip_pending_review
      if user.try(:forem_needs_moderation?)
        update_attribute(:state, 'approved')
      end
    end

    def approve_user_and_posts
      return unless state_changed?

      first_post = posts.by_created_at.first
      first_post.approve! unless first_post.approved?
      user.update_attribute(:forem_state, 'approved') if user.forem_state != 'approved'
    end
  end
end
