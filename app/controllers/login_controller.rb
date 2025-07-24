class LoginController < ApplicationController
  layout "login"
  def new
    redirect_to after_login_path(current_user) if logged_in?
  end

  def create
    # Busca usuário por email OU matrícula
    user = User.find_by(email: params[:email]) || User.find_by(matricula: params[:email])

    if user&.authenticate(params[:password])
      handle_successful_login(user)
    else
      handle_failed_login
    end
  end

  def destroy
    logout if logged_in?
    redirect_to login_path, notice: "Você saiu do sistema."
  end

  private

  def handle_successful_login(user)
    session[:user_id] = user.id
    redirect_to after_login_path(user), notice: "Login realizado com sucesso!", status: :see_other
  end


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
