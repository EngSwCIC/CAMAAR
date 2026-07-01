# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # POST /users/password (solicitar redefinição - Issue #107)
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    respond_to do |format|
      if successfully_sent?(resource)
        format.html { redirect_to new_user_session_path, notice: 'E-mail de redefinição de senha enviado com sucesso.' }
        format.json { render json: { message: 'E-mail de redefinição de senha enviado com sucesso.' }, status: :ok }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { message: 'E-mail não encontrado.', errors: resource.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/password (redefinir senha com token - Issue #107)
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    respond_to do |format|
      if resource.errors.empty?

        resource.update_column(:first_access, false) if resource.first_access?
        format.html { redirect_to new_user_session_path, notice: 'Senha redefinida com sucesso. Faça login.' }
        format.json { render json: { message: 'Senha redefinida com sucesso.' }, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { message: 'Token inválido ou expirado.', errors: resource.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
end
