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

    private
    def set_first_post_user
      post = self.posts.first
      post.user = self.user
    end
  end
end
