# frozen_string_literal: true

# Adicione um comentário de documentação para a classe UsersController.
class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]
  before_action :ensure_admin!, except: %i[edit update]

  # GET /users or /users.json
  def index
    @users = User.order(:name)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    # Permite que usuários editem apenas seu próprio perfil, ou admins editem qualquer um
    return if current_user.admin? || @user == current_user

    redirect_to root_path, alert: I18n.t('messages.access_denied')
  end

  # POST /users or /users.json
  def create
    @user = build_user_with_password
    save_user_and_respond
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    clean_password_params_if_blank
    update_user_and_respond
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: I18n.t('messages.user_destroyed') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def build_user_with_password
    user = User.new(user_params)
    user.password = generate_temp_password if user.password.blank?
    user
  end

  def save_user_and_respond
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: "Usuário criado com sucesso! Senha temporária: #{@user.password}" }
        format.json { render json: @user, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def clean_password_params_if_blank
    return if user_params[:password].present?

    params[:user].delete(:password)
    params[:user].delete(:password_confirmation)
  end

  def update_user_and_respond
    respond_to do |format|
      if @user.update(user_params.except(:password, :password_confirmation).compact)
        format.html { redirect_to users_path, notice: I18n.t('messages.user_updated') }
        format.json { render json: @user, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Gera senha temporária
  def generate_temp_password
    SecureRandom.hex(4)
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.expect(user: %i[email password password_confirmation name matricula role])
  end
end
