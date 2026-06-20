class SessionsController < ApplicationController
  def new
    redirect_to formularios_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path_for(user), notice: "Login realizado com sucesso."
    else
      flash.now[:alert] = "Email ou senha inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logout realizado com sucesso."
  end

  private

  def dashboard_path_for(user)
    case user.role
    when "student" then formularios_path
    when "admin" then relatorios_path
    when "coordinator" then departamento_path
    end
  end
end
