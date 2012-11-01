require_dependency "forem/application_controller"

module Forem
  module Admin
    class AuditLogsController < BaseController
      # GET /audit_logs
      # GET /audit_logs.json
      def index
        @audit_logs = AuditLog.all
  
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @audit_logs }
        end
      end
  
      # DELETE /audit_logs/1
      # DELETE /audit_logs/1.json
      def destroy
        @audit_log = AuditLog.find(params[:id])
        @audit_log.destroy
  
        respond_to do |format|
          format.html { redirect_to audit_logs_url }
          format.json { head :no_content }
        end
      end
    end
  end
end
