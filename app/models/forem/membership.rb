module Forem
  class Membership < ActiveRecord::Base
    include Tenacity
    
    belongs_to :group
    t_belongs_to :member, :class_name => Forem.user_class.to_s

    attr_accessible :member_id, :group_id
  end
end
