module Forem
  class View < ActiveRecord::Base
    belongs_to :topic
    belongs_to :user, :class_name => Forem.user_class.to_s

    validates :topic_id, :presence => true
  end
end
