module Forem
  class Admin::UsersController < ApplicationController
    def autocomplete
      users = Forem.user_class.forem_autocomplete(params[:term])
      render :json => users.map { |u| { :id => u.id, :value => u.send(Forem.autocomplete_field) } }
    end
  end
end
