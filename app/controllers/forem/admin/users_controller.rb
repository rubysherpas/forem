module Forem
  class Admin::UsersController < ApplicationController
    def autocomplete
      users = Forem.user_class.forem_autocomplete(params[:term])
      render :json => users.map(Forem.autocomplete_field.to_proc)
    end
  end
end
