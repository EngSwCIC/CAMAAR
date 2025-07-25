# frozen_string_literal: true

# Controller para gerenciar disciplinas.
class DisciplinasController < ApplicationController
  before_action :set_disciplina, only: %i[edit update destroy]

  # GET /disciplinas or /disciplinas.json
  #
  # Lista todas as disciplinas.
  #
  def index
    @disciplinas = Disciplina.all
  end

  # GET /disciplinas/1 or /disciplinas/1.json
  #
  # Exibe os detalhes de uma disciplina específica.
  #
  def show; end

  # GET /disciplinas/new
  #
  # Exibe o formulário para a criação de uma nova disciplina.
  #
  def new
    @disciplina = Disciplina.new
  end

  # GET /disciplinas/1/edit
  #
  # Exibe o formulário para a edição de uma disciplina existente.
  #
  def edit; end

  # POST /disciplinas or /disciplinas.json
  #
  # Cria uma nova disciplina com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +disciplina+ - Um hash com os atributos da disciplina.
  #
  # ==== Side Effects
  #
  # * Cria uma nova disciplina no banco de dados.
  # * Redireciona para a lista de disciplinas em caso de sucesso.
  # * Renderiza o formulário novamente em caso de falha.
  #
  def create
    @disciplina = Disciplina.new(disciplina_params)

    respond_to do |format|
      if @disciplina.save
        format.html { redirect_to disciplinas_url, notice: 'Disciplina criada com sucesso!' }
        format.json { render :show, status: :created, location: @disciplina }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @disciplina.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /disciplinas/1 or /disciplinas/1.json
  #
  # Atualiza uma disciplina existente com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da disciplina a ser atualizada.
  # * +disciplina+ - Um hash com os novos atributos da disciplina.
  #
  # ==== Side Effects
  #
  # * Atualiza a disciplina no banco de dados.
  # * Redireciona para a página da disciplina em caso de sucesso.
  # * Renderiza o formulário de edição novamente em caso de falha.
  #
  def update
    respond_to do |format|
      if @disciplina.update(disciplina_params)
        format.html { redirect_to disciplina_url(@disciplina), notice: 'Disciplina atualizada com sucesso!' }
        format.json { render :show, status: :ok, location: @disciplina }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @disciplina.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /disciplinas/1 or /disciplinas/1.json
  #
  # Exclui uma disciplina existente.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da disciplina a ser excluída.
  #
  # ==== Side Effects
  #
  # * Exclui a disciplina do banco de dados.
  # * Redireciona para a lista de disciplinas.
  #
  def destroy
    @disciplina.destroy!

    respond_to do |format|
      format.html { redirect_to disciplinas_url, status: :see_other, notice: 'Disciplina removida com sucesso!' }
      format.json { head :no_content }
    end
  end

  # GET /disciplinas/:id/turmas - AJAX endpoint para buscar turmas de uma disciplina
  #
  # Retorna as turmas de uma disciplina em formato JSON.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da disciplina.
  #
  # ==== Returns
  #
  # * JSON - Uma lista de turmas com seus respectivos professores.
  #
  def turmas
    @disciplina = Disciplina.find(params[:id])
    @turmas = @disciplina.turmas.includes(:professor)

    respond_to do |format|
      format.json do
        render json: @turmas.map { |turma|
          {
            id: turma.id,
            semestre: turma.semestre,
            professor_nome: turma.professor.name
          }
        }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_disciplina
    @disciplina = Disciplina.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def disciplina_params
    params.require(:disciplina).permit(:nome, :curso_id)
  end
end
