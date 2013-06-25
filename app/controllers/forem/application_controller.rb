require 'cancan'

class Forem::ApplicationController < Forem::ApplicationLogController
  rescue_from CanCan::AccessDenied do
    redirect_to root_path, :alert => t("forem.access_denied")
  end
  
  before_filter :redirect_banned_user

  def current_ability
    Forem::Ability.new(forem_user)
  end

  private
  def redirect_banned_user
    if forem_user.nil? || current_user.nil?
      flash[:notice] = 'You do not have access to the forums.'
      redirect_to ( Forem.sign_in_proc && Forem.sign_in_proc.call(request) ) || Forem.sign_in_path
    elsif forem_user.banned?
      flash[:notice] = 'You do not have access to the forums.'
      redirect_to main_app.root_path
    end
  end

  def authenticate_forem_user
    if !forem_user && !current_user
      session["user_return_to"] = request.fullpath
      flash.alert = t("forem.errors.not_signed_in")
      devise_route = "new_#{Forem.user_class.to_s.underscore}_session_path"
      sign_in_path = (Forem.sign_in_proc && Forem.sign_in_proc.call(request) ) || Forem.sign_in_path ||
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
  
  def forem_mod?
    forem_user && forem_user.forem_mod?
  end
  helper_method :forem_mod?

  def forem_admin_or_moderator?(forum)
    forem_user && (forem_user.forem_admin? || forum.moderator?(forem_user) || forem_user.forem_mod?)
  end
  helper_method :forem_admin_or_moderator?

end
