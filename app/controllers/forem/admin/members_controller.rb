module Forem
  class Admin::MembersController < ApplicationController

    def create
      user = Forem.user_class.where(Forem.autocomplete_field => params[:user]).first
      unless group.members.exists?(user.id)
        group.members << user
      end
      render :status => :ok
    end

    private

    def group
      @group ||= Group.find(params[:group_id])
    end
  end
end
