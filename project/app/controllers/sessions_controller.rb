##
# Cria e encerra sessões autenticadas por e-mail ou matrícula.
class SessionsController < ApplicationController
  layout "auth"

  ##
  # Exibe o formulário de autenticação.
  #
  # Não recebe argumentos.
  #
  # Retorna a resposta HTML construída pelo Rails.
  #
  # Efeitos colaterais: renderiza a view de login.
  def new
  end

  ##
  # Autentica as credenciais informadas e inicia a sessão do usuário.
  #
  # Não recebe argumentos explícitos; utiliza +params[:session]+.
  #
  # Retorna um redirecionamento ao painel quando autenticado ou uma resposta de
  # validação quando a senha é inválida ou ainda não foi definida.
  #
  # Efeitos colaterais: consulta o usuário, grava +session[:user_id]+ quando válido
  # e define mensagens de sucesso ou alerta.
  def create
    user = User.find_for_login(session_params[:identifier])

    return handle_pending_setup if user&.pending_password_setup?
    return handle_login_success(user) if user&.authenticate(session_params[:password])

    handle_login_failure
  end

  ##
  # Encerra a sessão autenticada atual.
  #
  # Não recebe argumentos.
  #
  # Retorna uma resposta de redirecionamento para o login.
  #
  # Efeitos colaterais: limpa todos os dados da sessão e define uma mensagem de sucesso.
  def destroy
    reset_session
    redirect_to login_path, notice: "Logout realizado com sucesso"
  end

  private

  ##
  # Filtra o identificador e a senha aceitos pelo login.
  #
  # Não recebe argumentos explícitos; lê +params[:session]+.
  #
  # Retorna ActionController::Parameters com +identifier+ e +password+.
  #
  # Efeitos colaterais: pode lançar ActionController::ParameterMissing.
  def session_params
    params.require(:session).permit(:identifier, :password)
  end

  def handle_pending_setup
    flash.now[:alert] = "Senha inicial precisa ser definida antes do acesso"
    render :new, status: :unprocessable_entity
  end

  def handle_login_success(user)
    session[:user_id] = user.id
    redirect_to root_path, notice: "Login realizado com sucesso"
  end

  def handle_login_failure
    flash.now[:alert] = "Email, matrícula ou senha inválidos"
    render :new, status: :unprocessable_entity
  end
end
