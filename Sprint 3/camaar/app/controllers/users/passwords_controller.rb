# frozen_string_literal: true

# Handles password recovery via e-mail token (Issue #107 - Redefinição de
# senha). Overrides Devise's PasswordsController to respond consistently
# in both HTML and JSON formats.
class Users::PasswordsController < Devise::PasswordsController
  # Sends the password-reset e-mail for the e-mail/matrícula in +resource_params+.
  #
  # Does not receive arguments directly (reads Devise's +resource_params+).
  # Returns no value; always renders or redirects.
  # Side effect: sends a password-reset e-mail when the account is found.
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      render_reset_instructions_sent
    else
      render_reset_instructions_failure
    end
  end

  # Resets the password using the token in +resource_params+.
  #
  # Does not receive arguments directly (reads Devise's +resource_params+).
  # Returns no value; always renders or redirects.
  # Side effects: updates the user's password and, on first access,
  # clears the +first_access+ flag.
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      finish_password_reset
    else
      render_password_reset_failure
    end
  end

  private

  # Renders the success response after the reset e-mail was sent.
  def render_reset_instructions_sent
    respond_to do |format|
      format.html { redirect_to new_user_session_path, notice: 'E-mail de redefinição de senha enviado com sucesso.' }
      format.json { render json: { message: 'E-mail de redefinição de senha enviado com sucesso.' }, status: :ok }
    end
  end

  # Renders the failure response when the reset e-mail could not be sent.
  def render_reset_instructions_failure
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: { message: 'E-mail não encontrado.', errors: resource.errors.full_messages }, status: :unprocessable_entity }
    end
  end

  # Clears the first-access flag (if set) and renders the success response.
  def finish_password_reset
    resource.update_column(:first_access, false) if resource.first_access?

    respond_to do |format|
      format.html { redirect_to new_user_session_path, notice: 'Senha redefinida com sucesso. Faça login.' }
      format.json { render json: { message: 'Senha redefinida com sucesso.' }, status: :ok }
    end
  end

  # Renders the failure response for an invalid or expired reset token.
  def render_password_reset_failure
    respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: { message: 'Token inválido ou expirado.', errors: resource.errors.full_messages }, status: :unprocessable_entity }
    end
  end
end
