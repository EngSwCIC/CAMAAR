class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token

  def after_sign_in_path_for(_resource)
    if admin_signed_in? # Assuming there is such a function
      # admins_page_path
      "/templates"
    elsif user_signed_in?
      users_page_path
    else
      root_path
    end
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
