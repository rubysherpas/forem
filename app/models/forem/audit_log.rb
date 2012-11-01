module Forem
  class AuditLog < ActiveRecord::Base
    attr_accessible :resource_action, :resource_id, :resource_type, :user_id, :action_type, :user_ip
    
    belongs_to :user, :class_name => Forem.user_class.to_s
  end
end
