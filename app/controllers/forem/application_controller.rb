class Forem::ApplicationController < ApplicationController
  def authenticate_forem_user
    if !current_user
      session[:return_to] = request.fullpath
      flash[:error] = t("forem.errors.not_signed_in")
      redirect_to "/sign_in" #TODO: Change to routing helper for flexibility
    end
  end

  def authenticate_forem_admin
    if !current_user || !current_user.forem_admin
      flash[:error] = t("forem.errors.access_denied")
      redirect_to forums_path #TODO: not positive where to redirect here
    end
  end
end
