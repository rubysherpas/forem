require 'cancan'

class Forem::ApplicationController < ApplicationController
  layout Forem.layout
  
  rescue_from CanCan::AccessDenied do
    redirect_to root_path, :alert => t("forem.access_denied")
  end

  def current_ability
    Forem::Ability.new(forem_user)
  end

  # Kaminari defaults page_method_name to :page, will_paginate always uses
  # :page
  def pagination_method
    defined?(Kaminari) ? Kaminari.config.page_method_name : :page
  end

  # Kaminari defaults param_name to :page, will_paginate always uses :page
  def pagination_param
    defined?(Kaminari) ? Kaminari.config.param_name : :page
  end
  helper_method :pagination_param

  private

  def authenticate_forem_user
    if !forem_user
      session["user_return_to"] = request.fullpath
      flash.alert = t("forem.errors.not_signed_in")
      devise_route = "new_#{Forem.user_class.to_s.underscore}_session_path"
      sign_in_path = Forem.sign_in_path ||
        (main_app.respond_to?(devise_route) && main_app.send(devise_route)) ||
        (main_app.respond_to?(:sign_in_path) && main_app.send(:sign_in_path))
      if sign_in_path
        redirect_to sign_in_path
      else
        raise "Forem could not determine the sign in path for your application. Please do one of these things:

1) Define sign_in_path in the config/routes.rb of your application like this:

or; 2) Set Forem.sign_in_path to a String value that represents the location of your sign in form, such as '/users/sign_in'."
      end
    end
  end

  def forem_admin?
    forem_user && forem_user.forem_admin?
  end
  helper_method :forem_admin?

  def forem_admin_or_moderator?(forum)
    forem_user && (forem_user.forem_admin? || forum.moderator?(forem_user))
  end
  helper_method :forem_admin_or_moderator?

end
