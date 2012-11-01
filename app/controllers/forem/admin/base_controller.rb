module Forem
  module Admin
    class BaseController < ApplicationController
      before_filter :authenticate_forem_admin

      def index
        # TODO: perhaps gather some stats here to show on the admin page?
      end
      
      protected
      
      def audit(resource, action)
        AuditLog.create(user_id: current_user.id, resource_id: resource.id, resource_type: resource.class.to_s, resource_action: action)
      end

      private

      def authenticate_forem_admin
        if !forem_user || !forem_user.forem_admin?
          flash.alert = t("forem.errors.access_denied")
          redirect_to forums_path #TODO: not positive where to redirect here
        end
      end
    end
  end
end
