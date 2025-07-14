class LoginController < ApplicationController
  def index
  end

  def login
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to authenticated_home_path, notice: "Logged in!"
    else
      flash.now[:alert] = "Senha ou email inválido"
      render :index, status: :unprocessable_entity
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path
  end
end
