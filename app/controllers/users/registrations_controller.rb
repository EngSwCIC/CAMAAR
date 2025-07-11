# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :ensure_admin, only: %i[new create]
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    def new
      build_resource({})
      resource.role = :aluno # Define role padrão
      yield resource if block_given?
      respond_with resource
    end

    # POST /resource
    def create
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_up!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    protected

    # Permite cadastro apenas para admins
    def ensure_admin
      return if user_signed_in? && current_user.admin?

      redirect_to root_path, alert: 'Apenas administradores podem cadastrar usuários.'
    end

    # Permite parâmetros adicionais para cadastro
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[name matricula role])
    end

    # Permite parâmetros adicionais para atualização
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[name matricula])
    end

    # Redireciona após cadastro bem-sucedido
    def after_sign_up_path_for(_resource)
      users_path
    end
  end
end
