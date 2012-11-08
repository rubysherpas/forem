module Forem
  class ApplicationLogController < ApplicationController
    
    protected
    
    def audit(resource, action, action_type)
      AuditLog.create(user_id: forem_user.id, user_ip: request.remote_ip, resource_id: resource.id, resource_type: resource.class.to_s, resource_action: action, action_type: action_type)
    end
  end
end