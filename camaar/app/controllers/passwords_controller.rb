class PasswordsController < ApplicationController
  def create
    user - User.find_by(email: params[:email])
    if @user.present?
      PasswordMailer.with(user: @user).reset.deliver_now
    end
  end

  def edit
    #Current.user - User.find_by(id:session[:user_id])
    #Rails.application.routes.url_helpers.edit_user_password_path(reset_password_token: user.send (:set_reset_password_token))
  end

  def update
    if Current.user.update(password_params)
      redirect_to root_path, notice: "Senha Atualizada!"
    end
  end

  private

  def passwords_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
