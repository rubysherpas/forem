class Forem::Post < ActiveRecord::Base
  set_table_name :forem_posts
  belongs_to :topic
  belongs_to :user
  belongs_to :reply_to, :class_name => "Post"

  has_many :replies, :class_name => "Post",
                     :foreign_key => "reply_to_id",
                     :dependent => :nullify

  validates :text, :presence => true
end
