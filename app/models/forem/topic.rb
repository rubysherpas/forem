module Forem
  class Topic < ActiveRecord::Base
    belongs_to :forum
    belongs_to :user
    has_many :posts, :dependent => :destroy
    accepts_nested_attributes_for :posts

    validates :subject, :presence => true

    before_save :set_first_post_user

    scope :by_most_recent_post, joins(:posts).order('forem_posts.created_at DESC').group('topic_id')

    def to_s
      subject
    end

    # Cannot use method name lock! because it's reserved by AR::Base
    def lock_topic!
      update_attribute(:locked, true)
    end

    # A Topic cannot be replied to if it's locked.
    def can_be_replied_to?
      !locked?
    end

    private
    def set_first_post_user
      post = self.posts.first
      post.user = self.user
    end
  end
end
