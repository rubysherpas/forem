module Forem
  module Admin
    class MembersController < BaseController
      def add
        user = Forem.user_class.where(:id => params[:user_id]).first
        unless group.members.exists?(user.id)
          group.members << user
        end
        redirect_to [:admin, group]
      end

      private

      def group
        @group ||= Forem::Group.find(params[:group_id])
      end
    end
  end
end
