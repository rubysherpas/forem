class Forem::Topic < ActiveRecord::Base
  set_table_name :forem_topics
  belongs_to :forum
  belongs_to :user
  has_many :posts
  accepts_nested_attributes_for :posts

  validates :subject, :presence => true

  before_save :set_first_post_user

  private
  
  def set_first_post_user
    post = self.posts.first
    post.user = self.user
  end
end
