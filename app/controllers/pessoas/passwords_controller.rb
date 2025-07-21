class Pessoas::PasswordsController < Devise::PasswordsController

  # Método chamado quando o token é inválido
  def assert_reset_token_passed
    if params[:reset_password_token].blank?
      set_flash_message(:alert, "Token de redefinição de senha é inválido") if is_navigational_format?
      redirect_to new_session_path(resource_name)
    end
  end

  # Também pode sobrescrever o método responsável pelo update para capturar token inválido
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash[:notice] = "Senha redefinida com sucesso!"
      sign_in(resource_name, resource)
      session[:email] = resource.email
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      if resource.errors.details[:reset_password_token].present?
        flash[:alert] = "Token de redefinição de senha é inválido"
      end
      respond_with resource
    end
  end
end
