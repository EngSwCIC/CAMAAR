class User::SessionsController < Devise::SessionsController
  def new
    # rota que leva para a root do programa
    render 'devise/sessions/new.html.erb'
  end

  def create
    # ainda não sei para que isso serve, mas é para criar uma sessão de usuário
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if !session[:return_to].blank?
      redirect_to session[:return_to]
      session[:return_to] = nil
    else
      respond_with resource, :location => after_sign_in_path_for(resource)
    end
  end

  protected

  def after_sign_in_path_for(resource)
    if current_user.sign_in_count == 1
      edit_passwords_path
    else
      if resource.dicente?
        home_dicente_path
      elsif resource.docente?
        home_docente_path
      else
        super
      end
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
