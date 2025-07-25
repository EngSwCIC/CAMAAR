# frozen_string_literal: true

module Users
  # Adicione um comentário de documentação para a classe Users::RegistrationsController.
  class RegistrationsController < Devise::RegistrationsController
    before_action :verificar_admin, only: %i[new create]
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    def new
      build_resource({})
      resource.role = 'aluno' # Define role padrão
      yield resource if block_given?
      respond_with resource
    end

    # POST /resource
    def create
      build_resource(sign_up_params)
      
      if resource.save
        flash[:notice] = 'Usuário criado com sucesso!'
        redirect_to users_path
      else
        clean_up_passwords resource
        set_minimum_password_length
        render :new, status: :unprocessable_entity
      end
    end

    private

    # Permite cadastro apenas para admins
    def verificar_admin
      return if current_user&.admin?

      flash[:alert] = 'Acesso negado. Apenas administradores podem cadastrar novos usuários.'
      redirect_to root_path
    end

    # Permite parâmetros adicionais para cadastro
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role, :name, :matricula)
    end

    # Permite parâmetros adicionais para atualização
    def account_update_params
      params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name, :matricula)
    end

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[name role matricula])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[name matricula])
    end

    # Redireciona após cadastro bem-sucedido
    def after_sign_up_path_for(resource)
      users_path
    end

    # Redireciona após cadastro quando inativo
    def after_inactive_sign_up_path_for(resource)
      users_path
    end
  end
end
