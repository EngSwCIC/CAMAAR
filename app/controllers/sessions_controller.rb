class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    # renderizar a página de login
  end

  def create
    user = User.find_by_login(params[:login])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Login realizado com sucesso!"
      redirect_to home_path
    elsif user && user.password_digest.nil? && user.invitation_token.present?
      redirect_to password_set_path(user.invitation_token), notice: "Este é seu primeiro acesso. Por favor, defina uma senha."
    else
      flash.now[:alert] = "Credenciais inválidas"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, flash: { logout: "Logout realizado com sucesso!" }
  end
end
