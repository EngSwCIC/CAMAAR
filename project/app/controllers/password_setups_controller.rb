class PasswordSetupsController < ApplicationController
  before_action :load_user

  def edit
    render_invalid_token unless @user
  end

  def update
    return render_invalid_token unless @user

    if password_params[:password] != password_params[:password_confirmation]
      flash.now[:alert] = "Confirmacao de senha nao confere"
      render :edit, status: :unprocessable_entity
    else
      @user.apply_new_password!(password_params[:password])
      redirect_to login_path, notice: "Senha definida com sucesso"
    end
  end

  private

  def load_user
    @token = params[:token]
    @user = User.find_by_setup_token(@token)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def render_invalid_token
    flash.now[:alert] = "Link de definicao de senha invalido ou expirado"
    render :invalid, status: :not_found
  end
end
