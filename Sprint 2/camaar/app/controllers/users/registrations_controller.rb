# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # POST /users (cadastrar usuário - Issue #100)
  def create
    build_resource(sign_up_params)
    resource.save
    if resource.persisted?
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
    else
      render json: {
        message: 'Erro ao cadastrar usuário.',
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :role, :department)
  end
end
