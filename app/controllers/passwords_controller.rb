class PasswordsController < ApplicationController
  INVALID_LINK_MESSAGE     = "Link de definição de senha inválido ou expirado".freeze
  INVALID_PASSWORD_MESSAGE = "Senha inválida".freeze

  before_action :load_user_from_email

  def edit
    render_invalid_link unless valid_link?
  end

  def update
    return render_invalid_link unless valid_link?

    new_password = params[:password].to_s
    return render_invalid_password if new_password.blank?

    @user.password = new_password
    @user.password_confirmation = params[:password_confirmation].to_s
    @user.primeiro_acesso = false

    if @user.save
      redirect_to login_path, notice: "Senha definida com sucesso"
    else
      @user.primeiro_acesso = true
      render_invalid_password
    end
  end

  private

  def load_user_from_email
    email = params[:email].to_s.strip
    @user = User.find_by(email: email) if email.present?
  end

  def valid_link?
    @user.present? && @user.primeiro_acesso
  end

  def render_invalid_link
    @invalid_link = true
    flash.now[:alert] = INVALID_LINK_MESSAGE
    render :edit, status: :unprocessable_entity
  end

  def render_invalid_password
    flash.now[:alert] = INVALID_PASSWORD_MESSAGE
    render :edit, status: :unprocessable_entity
  end
end
