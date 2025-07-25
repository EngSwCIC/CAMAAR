# frozen_string_literal: true

# Controller para gerenciar usuários.
class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]
  before_action :ensure_admin!, except: %i[show edit update]

  # GET /users or /users.json
  #
  # Lista todos os usuários em ordem alfabética.
  #
  def index
    @users = User.order(:name)
  end

  # GET /users/1
  #
  # Exibe os detalhes de um usuário específico.
  #
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  #
  # Exibe o formulário para a criação de um novo usuário.
  #
  def new
    @user = User.new
  end

  # GET /users/1/edit
  #
  # Exibe o formulário para a edição de um usuário existente.
  #
  def edit
    # Permite que usuários editem apenas seu próprio perfil, ou admins editem qualquer um
    return if current_user.admin? || @user == current_user

    redirect_to root_path, alert: I18n.t('messages.access_denied')
  end

  # POST /users or /users.json
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
    @user = build_user_with_password
    save_user_and_respond
  end

  # PATCH/PUT /users/1 or /users/1.json
  #
  # Atualiza um usuário existente com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +id+ - O ID do usuário a ser atualizado.
  # * +user+ - Um hash com os novos atributos do usuário.
  #
  # ==== Side Effects
  #
  # * Atualiza o usuário no banco de dados.
  # * Redireciona para a página do usuário em caso de sucesso.
  # * Renderiza o formulário de edição novamente em caso de falha.
  #
  def update
    clean_password_params_if_blank
    update_user_and_respond
  end

  # DELETE /users/1 or /users/1.json
  #
  # Exclui um usuário existente.
  #
  # ==== Attributes
  #
  # * +id+ - O ID do usuário a ser excluído.
  #
  # ==== Side Effects
  #
  # * Exclui o usuário do banco de dados.
  # * Redireciona para a lista de usuários.
  #
  def destroy
    return redirect_to root_path, alert: 'Acesso negado.' unless current_user&.admin?

    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: I18n.t('messages.user_destroyed') }
      format.json { head :no_content }
    end
  end

  # POST /users/adicionar_disciplina_aluno
  #
  # Adiciona uma disciplina a um aluno.
  #
  # ==== Attributes
  #
  # * +user_id+ - O ID do aluno.
  # * +turma_id+ - O ID da turma.
  #
  # ==== Side Effects
  #
  # * Cria uma nova matrícula para o aluno na turma.
  # * Redireciona para a página de edição do aluno.
  #
  def adicionar_disciplina_aluno
    return redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?

    @user = User.find(params[:user_id])
    @turma = Turma.find(params[:turma_id])

    # Verificar se o aluno já está matriculado nesta turma
    if @user.matriculas.exists?(turma_id: @turma.id)
      redirect_to edit_user_path(@user), alert: 'Este aluno já está matriculado nesta turma.'
      return
    end

    @matricula = @user.matriculas.create!(turma: @turma)

    redirect_to edit_user_path(@user),
                notice: "Aluno matriculado na disciplina #{@turma.disciplina.nome} - #{@turma.semestre}."
  end

  # DELETE /users/remover_disciplina_aluno
  #
  # Remove uma disciplina de um aluno.
  #
  # ==== Attributes
  #
  # * +matricula_id+ - O ID da matrícula a ser removida.
  #
  # ==== Side Effects
  #
  # * Exclui a matrícula do aluno.
  # * Redireciona para a página de edição do aluno.
  #
  def remover_disciplina_aluno
    return redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?

    if params[:matricula_id]
      @matricula = Matricula.find(params[:matricula_id])
    else
      @user = User.find(params[:user_id])
      disciplina = Disciplina.find(params[:disciplina_id])
      @matricula = @user.matriculas.joins(:turma).where(turmas: { disciplina: disciplina }).first
    end

    @user ||= @matricula.user

    @matricula.destroy!

    redirect_to edit_user_path(@user),
                notice: 'Disciplina removida com sucesso!'
  end

  # POST /users/adicionar_disciplina_professor
  #
  # Adiciona uma disciplina a um professor.
  #
  # ==== Attributes
  #
  # * +user_id+ - O ID do professor.
  # * +disciplina_id+ - O ID da disciplina.
  # * +semestre+ - O semestre da turma.
  #
  # ==== Side Effects
  #
  # * Cria uma nova turma para o professor na disciplina.
  # * Redireciona para a página de edição do professor.
  #
  def adicionar_disciplina_professor
    return redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?

    @user = User.find(params[:user_id])
    @disciplina = Disciplina.find(params[:disciplina_id])
    semestre = params[:semestre]

    # Verificar se já existe uma turma para este professor nesta disciplina neste semestre
    if @disciplina.turmas.exists?(professor_id: @user.id, semestre: semestre)
      redirect_to edit_user_path(@user), alert: 'Este professor já leciona esta disciplina neste semestre.'
      return
    end

    @turma = @disciplina.turmas.create!(
      professor: @user,
      semestre: semestre
    )

    redirect_to edit_user_path(@user),
                notice: "Professor cadastrado na disciplina #{@disciplina.nome} para o semestre #{semestre}."
  end

  # DELETE /users/remover_disciplina_professor
  #
  # Remove uma disciplina de um professor.
  #
  # ==== Attributes
  #
  # * +turma_id+ - O ID da turma a ser removida.
  #
  # ==== Side Effects
  #
  # * Exclui a turma do professor.
  # * Redireciona para a página de edição do professor.
  #
  def remover_disciplina_professor
    return redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?

    @turma = Turma.find(params[:turma_id])
    @user = @turma.professor

    @turma.destroy!

    redirect_to edit_user_path(@user),
                notice: 'Disciplina removida com sucesso!'
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
        format.html do
          redirect_to @user, notice: "Usuário criado com sucesso! Senha temporária: \\#{@user.password}"
        end
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
        format.html { redirect_to @user, notice: I18n.t('messages.user_updated') }
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
    if current_user&.admin?
      # Administradores podem editar todos os campos incluindo role e curso
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :matricula, :role, :curso)
    else
      # Usuários normais não podem editar role, mas podem editar curso
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :matricula, :curso)
    end
  end
end
