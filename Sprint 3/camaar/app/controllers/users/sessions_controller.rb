# frozen_string_literal: true

# Handles user authentication (Issue #104 - Sistema de Login).
# Overrides Devise's SessionsController to accept login via e-mail or
# matrícula and to respond consistently in both HTML and JSON formats.
class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # Authenticates the user with the +:login+/+:password+ params.
  #
  # Does not receive custom arguments (relies on Devise's +sign_in_params+).
  # Returns no value; it always renders or redirects the response.
  # Side effects: signs the user into the Warden session on success;
  # writes to the application log on unexpected authentication errors.
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    render_login_success
  rescue Warden::NotAuthenticated
    render_login_failure('Email/Matrícula ou senha inválidos.')
  rescue StandardError => e
    Rails.logger.error("Login error: #{e.message}")
    render_login_failure('Erro ao fazer login.')
  end

  # Ends the current user session.
  #
  # Does not receive arguments. Returns no value.
  # Side effect: signs the user out of the Warden session and
  # redirects (HTML) or renders a confirmation (JSON).
  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: { message: 'Logout realizado com sucesso.' }, status: :ok }
    end
  end

  private

  # Allows Devise to accept +:login+ in addition to +:email+ on sign in.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :email])
  end

  # Renders the success response for a completed login, in HTML or JSON.
  def render_login_success
    respond_to do |format|
      format.html { redirect_to dashboard_path }
      format.json { render json: login_success_payload, status: :ok }
    end
  end

  # Builds the JSON payload returned after a successful login.
  def login_success_payload
    {
      message: 'Login realizado com sucesso.',
      user: {
        id: resource.id,
        email: resource.email,
        name: resource.name,
        role: resource.role,
        department: resource.department
      }
    }
  end

  # Renders the failure response for a rejected login attempt.
  #
  # +message+ - the flash/JSON message describing why login failed.
  def render_login_failure(message)
    self.resource = resource_class.new
    flash.now[:alert] = message
    render :new, status: :unprocessable_entity
  end
end
