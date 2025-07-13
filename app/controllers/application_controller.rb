class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Adicionando métodos de autenticação
  helper_method :current_user, :logged_in?

  private

  # Método para obter o usuário atual
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

  # Verifica se o usuário está logado
  def logged_in?
    current_user.present?
  end

  # Redireciona usuários não logados
  def require_login
    unless logged_in?
      flash[:alert] = 'Por favor, faça login para acessar esta página.'
      redirect_to login_path
    end
  end

  # Métodos auxiliares para sessão (usados pelo SessionsController)
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