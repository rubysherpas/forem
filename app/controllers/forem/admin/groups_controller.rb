module Forem
  module Admin
    class GroupsController < BaseController
      def new
        @group = Group.new
      end

      def create
        @group = Group.new(params[:group])
        if @group.save
          flash[:notice] = t("forem.admin.group.created")
          redirect_to [:admin, @group]
        else
          flash[:alert] = t("forem.admin.group.not_created")
          render :new
        end
      end

      def show
        @group = Group.find(params[:id])
      end
    end
  end
end
