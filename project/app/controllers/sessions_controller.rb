class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_for_login(session_params[:identifier])

    if user&.pending_password_setup?
      flash.now[:alert] = "Senha inicial precisa ser definida antes do acesso"
      render :new, status: :unprocessable_entity
    elsif user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Login realizado com sucesso"
    else
      flash.now[:alert] = "Email, matricula ou senha invalidos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Logout realizado com sucesso"
  end

  private

  def session_params
    params.require(:session).permit(:identifier, :password)
  end
end
