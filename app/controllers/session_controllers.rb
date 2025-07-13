class SessionsController < ApplicationController
  # Exibe o formulário de login
  def new
    redirect_to root_path if logged_in?
  end

  # Processa o login
  def create
    user = User.find_by(email: params[:email].downcase)
    
    if user && user.authenticate(params[:password])
      login(user)
      remember(user) if params[:remember_me] == '1'
      redirect_to root_path, notice: 'Login realizado com sucesso!'
    else
      flash.now[:alert] = 'Email ou senha inválidos'
      render :new, status: :unprocessable_entity
    end
  end

  # Processa o logout
  def destroy
    logout if logged_in?
    redirect_to login_path, notice: 'Você saiu do sistema.'
  end

  private

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