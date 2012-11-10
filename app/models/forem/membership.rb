module Forem
  class Membership < ActiveRecord::Base
    belongs_to :group
    belongs_to :member, :class_name => Forem.user_class_string

    attr_accessible :member_id, :group_id
  end
end
