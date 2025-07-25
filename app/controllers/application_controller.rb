##
# Controller base da aplicação CAMAAR
#
# Define funcionalidades comuns a todos os controllers, incluindo:
# * Métodos de autenticação e autorização
# * Helpers para gerenciamento de sessão
# * Validações de segurança para navegadores modernos
#
# === Funcionalidades de Autenticação
# * current_user: Usuário atualmente logado
# * logged_in?: Verifica se há usuário logado
# * require_login: Força login para acessar ação
# * Suporte a "Lembrar-me" via cookies
#
# === Exemplo de uso em controllers filhos
#
#   class MeuController < ApplicationController
#     before_action :require_login
#
#     def index
#       if current_user.admin?
#         # Lógica para admin
#       end
#     end
#   end
#
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Adicionando métodos de autenticação
  helper_method :current_user, :logged_in?

  private

  ##
  # Obtém o usuário atualmente logado
  #
  # Verifica primeiro a sessão ativa, depois cookies de "lembrar-me".
  # Implementa autenticação dupla por segurança.
  #
  # === Retorno
  # +User+:: Usuário logado ou nil se não autenticado
  #
  # === Exemplo
  #   def index
  #     if current_user&.admin?
  #       @admin_data = load_admin_data
  #     end
  #   end
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        login(user)
        @current_user = user
      end
    end
  end

  ##
  # Verifica se há usuário logado no sistema
  #
  # === Retorno
  # +Boolean+:: true se há usuário autenticado
  #
  # === Exemplo
  #   def show
  #     if logged_in?
  #       # Mostrar conteúdo personalizado
  #     else
  #       # Mostrar conteúdo público
  #     end
  #   end
  def logged_in?
    current_user.present?
  end

  ##
  # Filter que força login para acessar a ação
  #
  # Redireciona usuários não autenticados para a página de login
  # com mensagem explicativa.
  #
  # === Uso
  #   class ProtectedController < ApplicationController
  #     before_action :require_login
  #   end
  def require_login
    unless logged_in?
      flash[:alert] = "Por favor, faça login para acessar esta página."
      redirect_to login_path
    end
  end

  ##
  # Inicia sessão para um usuário
  #
  # === Parâmetros
  # +user+:: Usuário para logar no sistema
  #
  # === Exemplo
  #   def create
  #     user = User.authenticate(params[:email], params[:password])
  #     if user
  #       login(user)
  #       redirect_to dashboard_path
  #     end
  #   end
  def login(user)
    session[:user_id] = user.id
  end

  ##
  # Encerra sessão do usuário atual
  #
  # Remove dados de sessão e cookies de "lembrar-me".
  #
  # === Exemplo
  #   def destroy
  #     logout if logged_in?
  #     redirect_to login_path, notice: 'Logout realizado'
  #   end
  def logout
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  ##
  # Ativa funcionalidade "Lembrar-me" para um usuário
  #
  # Gera token persistente armazenado em cookies criptografados.
  #
  # === Parâmetros
  # +user+:: Usuário para lembrar
  #
  # === Exemplo
  #   def create
  #     if params[:remember_me] == '1'
  #       remember(user)
  #     end
  #   end
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  ##
  # Remove dados de "Lembrar-me" para um usuário
  #
  # === Parâmetros
  # +user+:: Usuário para esquecer
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
