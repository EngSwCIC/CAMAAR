##
# Controller responsável pela autenticação de usuários
#
# Gerencia o processo completo de login e logout no sistema CAMAAR.
# Suporta autenticação por email ou matrícula, com redirecionamento
# baseado no tipo de usuário.
#
# === Funcionalidades
# * Login por email (todos os usuários)
# * Login por matrícula (apenas discentes)
# * Logout com limpeza de sessão
# * Redirecionamento baseado em permissões
# * Mensagens de feedback para o usuário
#
# === Rotas
#   GET  /login  - Formulário de login
#   POST /login  - Processamento do login
#   DELETE /logout - Logout do sistema
#
class LoginController < ApplicationController
  layout "login"

  ##
  # Exibe formulário de login
  #
  # Redireciona usuários já logados para área apropriada.
  #
  # === Template
  # Usa layout 'login' personalizado para interface de autenticação.
  def new
    redirect_to after_login_path(current_user) if logged_in?
  end

  ##
  # Processa tentativa de login
  #
  # Aceita login por email ou matrícula, valida credenciais e
  # redireciona para área apropriada baseada no tipo de usuário.
  #
  # === Parâmetros esperados
  # * +email+: Email ou matrícula do usuário
  # * +password+: Senha em texto plano
  #
  # === Responses
  # * Sucesso: Redirect para dashboard do usuário
  # * Falha: Renderiza formulário com erro
  def create
    # Busca usuário por email OU matrícula
    user = User.find_by(email: params[:email]) || User.find_by(matricula: params[:email])

    if user&.authenticate(params[:password])
      handle_successful_login(user)
    else
      handle_failed_login
    end
  end

  ##
  # Realiza logout do usuário atual
  #
  # Limpa sessão e cookies, redirecionando para página de login.
  def destroy
    logout if logged_in?
    redirect_to login_path, notice: "Você saiu do sistema."
  end

  private

  ##
  # Trata login bem-sucedido
  #
  # === Parâmetros
  # +user+:: Usuário autenticado com sucesso
  def handle_successful_login(user)
    session[:user_id] = user.id
    redirect_to after_login_path(user), notice: "Login realizado com sucesso!", status: :see_other
  end

  ##
  # Trata falha no login
  #
  # Exibe erro sem revelar se email/matrícula existe (segurança).

  def handle_failed_login
    flash.now[:alert] = "Email/matrícula ou senha inválidos"
    render :new, status: :unprocessable_entity
  end

  def login_params
    params.permit(:login, :password, :remember_me)
  end

  def redirect_after_login(user)
    redirect_to after_login_path(user), notice: "Login realizado com sucesso!"
  end

  ##
  # Determina página de destino após login baseado no tipo de usuário
  #
  # === Parâmetros
  # +user+:: Usuário logado
  #
  # === Retorno
  # +String+:: Path para redirecionamento
  #
  # === Lógica de Redirecionamento
  # * Admin: Página de templates para gerenciamento
  # * Outros: Página de templates para responder

  def after_login_path(user)
    if user.admin?
      admin_templates_path  # Mudou aqui
    else
      user_templates_path   # Mudou aqui
    end
  end

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
