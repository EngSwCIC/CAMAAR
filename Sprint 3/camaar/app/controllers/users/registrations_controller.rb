# frozen_string_literal: true

# Handles user self-registration via the Devise endpoint (Issue #100 -
# Cadastrar usuários do sistema). Responds exclusively in JSON format.
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # Creates a new user account from the posted JSON body.
  #
  # Does not receive explicit arguments; reads the permitted attributes
  # via +sign_up_params+.
  # Returns no value; renders a JSON response.
  # Side effects: persists a new +User+ record on success (status 201);
  # returns validation errors on failure (status 422). No e-mail is sent.
  def create
    build_resource(sign_up_params)
    resource.save
    resource.persisted? ? render_registration_success : render_registration_failure
  end

  private

  # Renders the success response after a user is created (status 201).
  def render_registration_success
    render json: {
      message: 'Usuário cadastrado com sucesso.',
      user: {
        id: resource.id,
        email: resource.email,
        name: resource.name,
        role: resource.role,
        department: resource.department
      }
    }, status: :created
  end

  # Renders the failure response when the user could not be saved (status 422).
  def render_registration_failure
    render json: {
      message: 'Erro ao cadastrar usuário.',
      errors: resource.errors.full_messages
    }, status: :unprocessable_entity
  end

  # Returns the subset of +params[:user]+ that is safe to mass-assign.
  #
  # No arguments. Returns an +ActionController::Parameters+ instance.
  # No side effects.
  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :role, :department)
  end
end
