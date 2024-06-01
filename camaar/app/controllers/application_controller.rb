class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_user)
    users_page_path
  end

  def after_sign_in_path_for(_admin)
    admins_page_path
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[username email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: %i[email password]
    devise_parameter_sanitizer.permit :define, keys: [:email]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
