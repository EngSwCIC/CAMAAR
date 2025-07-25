# frozen_string_literal: true

module Admin
  # Controller para o gerenciamento de usuários por administradores.
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin

    # GET /admin/users/new
    #
    # Exibe o formulário para a criação de um novo usuário.
    #
    def new
      @user = User.new
    end

    # POST /admin/users
    #
    # Cria um novo usuário com os parâmetros fornecidos.
    #
    # ==== Attributes
    #
    # * +user+ - Um hash com os atributos do usuário.
    #
    # ==== Side Effects
    #
    # * Cria um novo usuário no banco de dados.
    # * Redireciona para a lista de usuários em caso de sucesso.
    # * Renderiza o formulário novamente em caso de falha.
    #
    def create
      @user = User.new(user_params)
      @user.password = generate_temp_password if @user.password.blank?

      if @user.save
        redirect_to users_path, notice: "Usuário criado com sucesso! Senha temporária: #{@user.password}"
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :name, :matricula, :role, :password, :password_confirmation)
    end

    def ensure_admin
      redirect_to root_path, alert: I18n.t('messages.access_denied') unless current_user.admin?
    end

    def generate_temp_password
      SecureRandom.hex(4) # Gera senha temporária de 8 caracteres
    end
  end
end
