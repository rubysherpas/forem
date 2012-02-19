class ApplicationController < ActionController::Base
  protect_from_forgery

  def forem_user
    current_user
  end
  helper_method :forem_user

  def sign_in_path
    new_user_session_path
  end
end
