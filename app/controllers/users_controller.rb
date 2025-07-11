# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :ensure_admin!, except: %i[show edit update]

  # GET /users or /users.json
  def index
    @users = User.order(:name)
  end

  # GET /users/1 or /users/1.json
  def show
    # Permite que usuários vejam apenas seu próprio perfil, ou admins vejam qualquer um
    return if current_user.admin? || @user == current_user

    redirect_to root_path, alert: 'Acesso negado!'
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    # Permite que usuários editem apenas seu próprio perfil, ou admins editem qualquer um
    return if current_user.admin? || @user == current_user

    redirect_to root_path, alert: 'Acesso negado!'
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    @user.password = generate_temp_password if @user.password.blank?

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "Usuário criado com sucesso! Senha temporária: #{@user.password}" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    # Remove password params se estiverem vazios (para não sobrescrever)
    if user_params[:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    respond_to do |format|
      if @user.update(user_params.except(:password, :password_confirmation).compact)
        format.html { redirect_to @user, notice: 'Usuário atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: 'Usuário removido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
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
