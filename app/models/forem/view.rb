module Forem
  class View < ActiveRecord::Base
    belongs_to :viewable, :polymorphic => true
    belongs_to :user, :class_name => Forem.user_class.to_s

    validates :viewable_id, :presence => true
    validates :viewable_type, :presence => true

    def viewed_at
      updated_at
    end
  end
end
