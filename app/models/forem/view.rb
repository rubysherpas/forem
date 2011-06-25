module Forem
  class View < ActiveRecord::Base
    belongs_to :topic
    belongs_to :user

    validates :topic_id, :presence => true
  end
end
