class Forem::ApplicationController < ApplicationController
  def authenticate_forem_user
    if !current_user
      session[:return_to] = request.fullpath
      flash[:error] = t("forem.errors.not_signed_in")
      redirect_to "/sign_in" #TODO: Change to routing helper for flexibility
    end
  end

  # dummy method
  def current_user
  end
end
