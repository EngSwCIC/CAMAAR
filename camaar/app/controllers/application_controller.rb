class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, unless: :allowed_path?

  def after_sign_in_path_for(_resource)
    if admin_signed_in?
      admins_page_path
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

  private

  def allowed_path?
    allowed_paths = [
      root_path,
      new_user_session_path,
      new_user_password_path,
      new_admin_session_path,
      new_admin_password_path
    ]

    allowed_paths.include?(request.path) ||
      valid_reset_password_path? ||
      valid_registration_path? ||
      valid_confirmation_path?
  end

  def valid_reset_password_path?
    request.path == edit_user_password_path && params[:reset_password_token].present?
  end

  def valid_registration_path?
    request.path == new_user_registration_path && params[:registration_token].present?
  end

  def valid_confirmation_path?
    request.path == user_confirmation_path && params[:confirmation_token].present?
  end

  def authenticate_user!
    return if user_signed_in? || admin_signed_in?

    render json: { error: 'Acesso Proibido' }, status: :forbidden
  end
end
