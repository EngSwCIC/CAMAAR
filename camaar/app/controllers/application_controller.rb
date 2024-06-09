class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, unless: :devise_controller?
  # before_action :authenticate_user!, unless: :allowed_path?
  # before_action :redirect_signed_in, only: [:index]

  protected

  def set_admin_data
    @coordinator = Coordinator.find_by({ email: current_admin.email })
    @department = Department.find_by_id(@coordinator.department_id) if @coordinator
  end

  def configure_permitted_parameters
    added_attrs = %i[username email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: %i[email password]
    devise_parameter_sanitizer.permit :define, keys: [:email]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def set_return_to
    session[:return_to] ||= request.referer
    @return_to = session[:return_to]
  end

  private

  def after_sign_in_path_for(_resource)
    if admin_signed_in?
      # admins_page_path
      templates_path
    elsif user_signed_in?
      users_page_path
    else
      root_path
    end
  end

  def authenticate_user!
    return if user_signed_in? || admin_signed_in?
  end
end
