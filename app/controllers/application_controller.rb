class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Permite os campos extras do CAMAAR ao convidar e ao aceitar o convite (issue #5)
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: %i[nome matricula perfil])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[nome matricula perfil])
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
