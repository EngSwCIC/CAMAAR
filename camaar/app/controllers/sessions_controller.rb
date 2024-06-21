=begin
class SessionsController < ApplicationController
  def create
    username = params[:username]
    password = params[:password]

    user = User.find_by(usuario: username)

    if user && user.senha == password
      redirect_to root_path, notice: 'Welcome, user!'
    else
      flash[:alert] = 'Invalid username or password'
      redirect_to :login
    end
  end
end
=end

class SessionsController < ApplicationController

  def teste_create
    username = params[:username]
    password = params[:password]

    user = User.find_by(usuario: username)

    if user && user.senha == password
      redirect_to login_path, notice: 'Login realizado com sucesso!'
    else
      flash[:alert] = 'Invalid username or password'
      redirect_to login_path
    end
  end


  def new
    # Ação para renderizar a página de login (login.html.erb)
  end

  def verify_user
    username = params[:username]
    user = User.find_by(usuario: username)

    if user
      render json: { found: true, url: recuperar_senha_path(username: username) }
    else
      render json: { found: false, message: 'Usuário não encontrado' }
    end
  end

  def create
    user = User.find_by(usuario: params[:username])

    if user.nil?
      flash[:alert] = "Usuário não encontrado. Por favor, verifique o usuário informado."
      redirect_to login_path
    elsif params[:password].blank? && user.senha.nil?
      redirect_to recuperar_senha_path(usuario: params[:username])
    elsif user.senha == params[:password]
      flash[:notice] = "Login realizado com sucesso!"
      session[:user_id] = user.id # Armazenar o ID do usuário na sessão
      redirect_to home_path
    else
      flash[:alert] = "Senha incorreta. Por favor, verifique sua senha."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Você saiu com sucesso."
    redirect_to login_path
  end
end


