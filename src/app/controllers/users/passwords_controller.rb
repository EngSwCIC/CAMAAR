class Users::PasswordsController < DeviseController
  
  append_before_action :assert_reset_token_passed, only: :edit

  # GET /resource/password/new
  def new
    self.resource = resource_class.new
  end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      respond_with({}, location: new_session_path(resource_name))
    else
      respond_with(resource)
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    @token = params[:reset_password_token]
    if User.with_reset_password_token(@token)
      resource.reset_password_token = @token
    else
      redirect_to new_user_session_path, notice: "O link que tentou utilizar expirou."
    end
    set_minimum_password_length
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    set_minimum_password_length
    if resource.errors.empty?
      # Consegue confirmar o usuário se ele ainda não está confirmado
      # Dessa forma a conta ainda não está confirmada sem definir a senha a primeira vez
      # A única forma de confirmar a conta é defininindo a senha
      resource.confirm if !resource.confirmed?
      sign_in(resource_name, resource)
      respond_with resource, location: root_path(resource)
    else
      respond_with resource
    end
  end

  protected
  
    def assert_reset_token_passed
      if params[:reset_password_token].blank?
        set_flash_message(:alert, :no_token)
        redirect_to new_session_path(resource_name)
      end
    end

    def translation_scope
      'devise.passwords'
    end
end