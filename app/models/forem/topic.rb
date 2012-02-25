module Forem
  class Topic < ActiveRecord::Base
    attr_protected :pinned, :locked

    belongs_to :forum
    has_many   :views
    has_many   :subscriptions
    belongs_to :user, :class_name => Forem.user_class.to_s

    has_many :posts, :dependent => :destroy, :order => "created_at ASC"
    accepts_nested_attributes_for :posts

    validates :subject, :presence => true

    before_save :set_first_post_user
    after_create :subscribe_poster

    class << self
      def visible
        where(:hidden => false)
      end

      def by_pinned
        order('forem_topics.pinned DESC, forem_topics.id')
      end

      def by_most_recent_post
        includes(:posts).
        order('forem_posts.created_at DESC, forem_topics.id')
      end

      def by_pinned_or_most_recent_post
        includes(:posts).
        order('forem_topics.pinned DESC').
        order('forem_posts.created_at DESC').
        order('forem_topics.id')
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

    # A Topic cannot be replied to if it's locked.
    def can_be_replied_to?
      !locked?
    end

    def view_for(user)
      views.find_by_user_id(user.id)
    end

    # Track when users last viewed topics
    def register_view_by(user)
      if user
        view = views.find_or_create_by_user_id(user.id)
        view.increment!("count")
      end
    end

    def subscribe_poster
      subscribe_user(self.user_id)
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

    def subscription_for user_id
      subscriptions.first(:conditions => { :subscriber_id=>user_id })
    end

    protected
    def set_first_post_user
      post = self.posts.first
      post.user = self.user
    end
  end
end
