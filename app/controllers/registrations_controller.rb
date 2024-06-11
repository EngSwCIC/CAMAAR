class RegistrationsController < ApplicationController
  def index
    render 'create'
  end

  def create
    email = user_params[:email]
    password = user_params[:password]
    password_confirmation = user_params[:password_confirmation]

    @user = User.criarUser(email, password, password_confirmation)
    
    if @user.present? && @user.persisted?
      redirect_to login_path, notice: "User successfully created!"
    else
      flash[:error] = "Todos os campos devem ser preenchidos e as senhas devem coincidir."
      render :create
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end