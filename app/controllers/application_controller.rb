class ApplicationController < ActionController::Base #:nodoc:
  allow_browser versions: :modern

  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Permite os campos extras do CAMAAR ao convidar e ao aceitar o convite (issue #5)
  def configure_permitted_parameters #:nodoc:
    devise_parameter_sanitizer.permit(:invite, keys: %i[nome matricula perfil])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[nome matricula perfil])
  end

  def after_sign_in_path_for(resource) #:nodoc:
    root_path
  end

  def after_sign_out_path_for(resource) #:nodoc:
    new_user_session_path
  end
end
