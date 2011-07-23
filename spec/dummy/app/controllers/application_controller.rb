class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :forem_user

  def forem_user
    current_user
  end
end
