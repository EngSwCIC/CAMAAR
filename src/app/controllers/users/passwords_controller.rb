  # Controladora para definição de senha do usuário
  # Para usuários novos, confirmando a conta e definindo a senha.
  # Também para redefinir a senha de usuários já confirmados que esqueceram.

class Users::PasswordsController < DeviseController
  # Verifica, antes de acessar o método edit, se foi passado algum token como argumento
  append_before_action :assert_reset_token_passed, only: :edit


  # Cria uma instância do usuário para armazenar eventuais erros.
  # Metodo Http GET /users/password/new
  def new
    self.resource = resource_class.new
  end

  # Recebe o email para envio da redefinição de senha.
  # Além disso, se for enviado o email corretamente, redireciona para a tela de login.
  # Caso não ocorra, permanece na página e mostra eventual erro.
  # Metodo Http POST /users/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      respond_with({}, location: new_session_path(resource_name))
    else
      respond_with(resource)
    end
  end

  # Recebe um token como argumento.
  # Se o token for inválido, redireciona para a tela de login com um erro.
  # Caso contrário, continua na tela de definição de senha.
  # Metodo Http GET /users/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    token = params[:reset_password_token]
    if User.with_reset_password_token(token)
      resource.reset_password_token = token
    else
      redirect_to new_user_session_path, notice: "O link que tentou utilizar expirou."
    end
    set_minimum_password_length
  end

  # Consegue confirmar o usuário se ele ainda não está confirmado
  # Dessa forma a conta ainda não está confirmada sem definir a senha a primeira vez
  # A única forma de confirmar a conta é defininindo a senha
  # Metodo Http PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    set_minimum_password_length
    if resource.errors.empty?
      sign_in_confirm(resource)
      respond_with resource, location: root_path(resource)
    else
      respond_with resource
    end
  end

  protected
    # Confirma as contas ainda não confirmadas e já autoriza a conta a acessar a Home
    def sign_in_confirm(resource)
      resource.confirm if !resource.confirmed?
      sign_in(resource_name, resource)
    end

    # Verifica se o token foi passado como argumento
    def assert_reset_token_passed
      if params[:reset_password_token].blank?
        redirect_to new_user_session_path, notice: "Para acessar precisa de token."
      end
    end
end