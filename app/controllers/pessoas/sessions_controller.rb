class Pessoas::SessionsController < Devise::SessionsController
  layout 'login'

  before_action :configure_sign_in_params, only: [:create]
  before_action :set_devise_vars, only: [:new, :create]

  def create
    self.resource = warden.authenticate(auth_options)
    if self.resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      session[:email] = resource.email
      
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      flash.now[:alert] = "Login ou senha inválidos"
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render :new, status: :unauthorized }
    end
  end

  protected

  def configure_sign_in_params
    # Permite email e password na autenticação
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :matricula])
  end

  def after_sign_in_path_for(resource)
    flash[:notice] = "Login efetuado com sucesso"
    dashboard_path
  end

  private

  def set_devise_vars
    # Torna as variáveis disponíveis na view
    @resource = resource_class.new(sign_in_params)
    @resource_name = resource_name
    @devise_mapping = Devise.mappings[:pessoa]
  end
end
