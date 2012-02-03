module Forem
  class View < ActiveRecord::Base
    belongs_to :topic
    belongs_to :user, :class_name => Forem.user_class.to_s

    scope :visible, joins(:topic).where("forem_topics.hidden" => false)
    
    validates :topic_id, :presence => true
  end
end
