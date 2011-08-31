module Forem
  class Post < ActiveRecord::Base
    belongs_to :topic
    belongs_to :user, :class_name => Forem.user_class.to_s, :foreign_key => :user_id
    belongs_to :reply_to, :class_name => "Post"

    has_many :replies, :class_name => "Post",
                       :foreign_key => "reply_to_id",
                       :dependent => :nullify

    validates :text, :presence => true
  end
end
