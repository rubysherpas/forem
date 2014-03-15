module Forem
  module Admin
    class BaseController < ApplicationController
      layout Forem.layout
      
      before_filter :authenticate_forem_admin

      def index
        # TODO: perhaps gather some stats here to show on the admin page?
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
