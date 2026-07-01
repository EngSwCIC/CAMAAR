# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # POST /users/sign_in
  def create
    begin
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)

      respond_to do |format|
        format.html { redirect_to dashboard_path }
        format.json do
          render json: {
            message: 'Login realizado com sucesso.',
            user: {
              id: resource.id,
              email: resource.email,
              name: resource.name,
              role: resource.role,
              department: resource.department
            }
          }, status: :ok
        end
      end
    rescue Warden::InvalidCredentials => e
      flash.now[:alert] = 'Email/Matrícula ou senha inválidos.'
      render :new, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error("Login error: #{e.message}")
      flash.now[:alert] = "Erro ao fazer login."
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /users/sign_out
  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: { message: 'Logout realizado com sucesso.' }, status: :ok }
    end
  end

  private

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :email])
  end

  def respond_to_on_destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: { message: 'Logout realizado com sucesso.' }, status: :ok }
    end
  end
end
