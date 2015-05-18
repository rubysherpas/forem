module Forem
  class CategorySubscription < ActiveRecord::Base
    belongs_to :monitor, :class_name => Forem.user_class.to_s
    belongs_to :category

    validates :monitor_id, :presence => true
  end
end
