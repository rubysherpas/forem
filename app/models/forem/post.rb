module Forem
  class Post < ActiveRecord::Base
    belongs_to :topic
    belongs_to :user, :class_name => Forem.user_class.to_s
    belongs_to :reply_to, :class_name => "Post"

    has_many :replies, :class_name => "Post",
                       :foreign_key => "reply_to_id",
                       :dependent => :nullify

    validates :text, :presence => true

    def owner_or_admin?(other_user)
      self.user == other_user || other_user.forem_admin?
    end
  end
end
