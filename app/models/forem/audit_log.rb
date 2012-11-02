module Forem
  class AuditLog < ActiveRecord::Base
    attr_accessible :resource_action, :resource_id, :resource_type, :user_id, :action_type, :user_ip
    
    belongs_to :user, :class_name => Forem.user_class.to_s
    
    def resource
      case resource_type
      when Forem::Category.to_s
        Forem::Category.find resource_id
      when Forem::Forum.to_s
        Forem::Forum.find resource_id
      when Forem::Topic.to_s
        Forem::Topic.find resource_id
      when Forem::Post.to_s
        Forem::Post.find resource_id
      end
      
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
end
