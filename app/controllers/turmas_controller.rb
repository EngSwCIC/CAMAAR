# frozen_string_literal: true

# Controller para gerenciar turmas.
class TurmasController < ApplicationController
  before_action :set_turma, only: %i[show edit update destroy]

  # GET /turmas or /turmas.json
  #
  # Lista todas as turmas.
  #
  def index
    @turmas = Turma.all
  end

  # GET /turmas/1 or /turmas/1.json
  #
  # Exibe os detalhes de uma turma específica.
  #
  def show; end

  # GET /turmas/new
  #
  # Exibe o formulário para a criação de uma nova turma.
  #
  def new
    @turma = Turma.new
  end

  # GET /turmas/1/edit
  #
  # Exibe o formulário para a edição de uma turma existente.
  #
  def edit; end

  # POST /turmas or /turmas.json
  #
  # Cria uma nova turma com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +turma+ - Um hash com os atributos da turma.
  #
  # ==== Side Effects
  #
  # * Cria uma nova turma no banco de dados.
  # * Redireciona para a página da turma em caso de sucesso.
  # * Renderiza o formulário novamente em caso de falha.
  #
  def create
    @turma = Turma.new(turma_params)

    respond_to do |format|
      if @turma.save
        format.html { redirect_to @turma, notice: 'Turma was successfully created.' }
        format.json { render :show, status: :created, location: @turma }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @turma.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /turmas/1 or /turmas/1.json
  #
  # Atualiza uma turma existente com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da turma a ser atualizada.
  # * +turma+ - Um hash com os novos atributos da turma.
  #
  # ==== Side Effects
  #
  # * Atualiza a turma no banco de dados.
  # * Redireciona para a página da turma em caso de sucesso.
  # * Renderiza o formulário de edição novamente em caso de falha.
  #
  def update
    respond_to do |format|
      if @turma.update(turma_params)
        format.html { redirect_to @turma, notice: 'Turma was successfully updated.' }
        format.json { render :show, status: :ok, location: @turma }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @turma.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /turmas/1 or /turmas/1.json
  #
  # Exclui uma turma existente.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da turma a ser excluída.
  #
  # ==== Side Effects
  #
  # * Exclui a turma do banco de dados.
  # * Redireciona para a lista de turmas.
  #
  def destroy
    @turma.destroy!

    respond_to do |format|
      format.html { redirect_to turmas_path, status: :see_other, notice: 'Turma was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_turma
    @turma = Turma.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def turma_params
    params.require(:turma).permit(:semestre, :professor_id, :disciplina_id)
  end
end
