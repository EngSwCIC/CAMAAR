class SessionsController < ApplicationController
  def new
  end

  def create
    identifier = params[:identifier].to_s.strip

    user = User.find_by(email: identifier) || User.find_by(matricula: identifier)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      if user.perfil == "Administrador"
        redirect_to admin_dashboard_path
      else
        redirect_to discente_dashboard_path
      end
    else
      flash.now[:alert] = "Usuário e/ou senha inválidos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_path
  end
end