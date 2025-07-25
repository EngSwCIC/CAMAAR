# frozen_string_literal: true

# Controller para gerenciar cursos.
class CursosController < ApplicationController
  before_action :set_curso, only: %i[show edit update destroy]

  # GET /cursos or /cursos.json
  #
  # Lista todos os cursos em ordem alfabética.
  #
  def index
    @cursos = Curso.order(:nome)
  end

  # GET /cursos/1 or /cursos/1.json
  #
  # Exibe os detalhes de um curso específico.
  #
  def show; end

  # GET /cursos/new
  #
  # Exibe o formulário para a criação de um novo curso.
  #
  def new
    @curso = Curso.new
  end

  # GET /cursos/1/edit
  #
  # Exibe o formulário para a edição de um curso existente.
  #
  def edit; end

  # POST /cursos or /cursos.json
  #
  # Cria um novo curso com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +curso+ - Um hash com os atributos do curso.
  #
  # ==== Side Effects
  #
  # * Cria um novo curso no banco de dados.
  # * Redireciona para a lista de cursos em caso de sucesso.
  # * Renderiza o formulário novamente em caso de falha.
  #
  def create
    @curso = Curso.new(curso_params)

    respond_to do |format|
      if @curso.save
        format.html { redirect_to cursos_path, notice: I18n.t('messages.course_created') }
        format.json { render json: @curso, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @curso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cursos/1 or /cursos/1.json
  #
  # Atualiza um curso existente com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +id+ - O ID do curso a ser atualizado.
  # * +curso+ - Um hash com os novos atributos do curso.
  #
  # ==== Side Effects
  #
  # * Atualiza o curso no banco de dados.
  # * Redireciona para a página do curso em caso de sucesso.
  # * Renderiza o formulário de edição novamente em caso de falha.
  #
  def update
    respond_to do |format|
      if @curso.update(curso_params)
        format.html { redirect_to curso_url(@curso), notice: I18n.t('messages.course_updated') }
        format.json { render json: @curso, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @curso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cursos/1 or /cursos/1.json
  #
  # Exclui um curso existente.
  #
  # ==== Attributes
  #
  # * +id+ - O ID do curso a ser excluído.
  #
  # ==== Side Effects
  #
  # * Exclui o curso do banco de dados.
  # * Redireciona para a lista de cursos.
  #
  def destroy
    @curso.destroy!

    respond_to do |format|
      format.html { redirect_to cursos_path, status: :see_other, notice: I18n.t('messages.course_destroyed') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_curso
    @curso = Curso.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def curso_params
    params.require(:curso).permit(:nome)
  end
end
