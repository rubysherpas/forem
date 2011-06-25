module Forem
  class Topic < ActiveRecord::Base
    attr_protected :pinned, :locked

    belongs_to :forum
    has_many   :views
    belongs_to :user, :class_name => Forem.user_class.to_s
    
    has_many :posts, :dependent => :destroy, :order => "created_at ASC"
    accepts_nested_attributes_for :posts

    validates :subject, :presence => true

    before_save :set_first_post_user

    scope :by_pinned, order('forem_topics.pinned DESC, forem_topics.id')
    scope :by_most_recent_post, joins(:posts).order('forem_posts.created_at DESC, forem_topics.id').group('topic_id')
    scope :by_pinned_or_most_recent_post, includes(:posts).
                                          order('forem_topics.pinned DESC').
                                          order('forem_posts.created_at DESC').
                                          order('forem_topics.id')

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

    # Track when users last viewed topics
    def register_view_by(user)
      if user
        view = views.find_or_create_by_user_id(user.id)
        view.increment!("count")
      end
    end

    private
    def set_first_post_user
      post = self.posts.first
      post.user = self.user
    end
  end
end
