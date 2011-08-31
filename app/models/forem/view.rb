module Forem
  class View < ActiveRecord::Base
    belongs_to :topic
    belongs_to :user, :class_name => Forem.user_class.to_s, :foreign_key => :user_id

    validates :topic_id, :presence => true
  end
end
