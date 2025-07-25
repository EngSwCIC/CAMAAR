# frozen_string_literal: true

# Controller para gerenciar matrículas.
class MatriculasController < ApplicationController
  before_action :set_matricula, only: %i[show edit update destroy]

  # GET /matriculas or /matriculas.json
  #
  # Lista todas as matrículas.
  #
  def index
    @matriculas = Matricula.all
  end

  # GET /matriculas/1 or /matriculas/1.json
  #
  # Exibe os detalhes de uma matrícula específica.
  #
  def show; end

  # GET /matriculas/new
  #
  # Exibe o formulário para a criação de uma nova matrícula.
  #
  def new
    @matricula = Matricula.new
  end

  # GET /matriculas/1/edit
  #
  # Exibe o formulário para a edição de uma matrícula existente.
  #
  def edit; end

  # POST /matriculas or /matriculas.json
  #
  # Cria uma nova matrícula com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +matricula+ - Um hash com os atributos da matrícula.
  #
  # ==== Side Effects
  #
  # * Cria uma nova matrícula no banco de dados.
  # * Redireciona para a página da matrícula em caso de sucesso.
  # * Renderiza o formulário novamente em caso de falha.
  #
  def create
    @matricula = Matricula.new(matricula_params)

    respond_to do |format|
      if @matricula.save
        format.html { redirect_to @matricula, notice: 'Matricula was successfully created.' }
        format.json { render :show, status: :created, location: @matricula }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @matricula.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matriculas/1 or /matriculas/1.json
  #
  # Atualiza uma matrícula existente com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da matrícula a ser atualizada.
  # * +matricula+ - Um hash com os novos atributos da matrícula.
  #
  # ==== Side Effects
  #
  # * Atualiza a matrícula no banco de dados.
  # * Redireciona para a página da matrícula em caso de sucesso.
  # * Renderiza o formulário de edição novamente em caso de falha.
  #
  def update
    respond_to do |format|
      if @matricula.update(matricula_params)
        format.html { redirect_to @matricula, notice: 'Matricula was successfully updated.' }
        format.json { render :show, status: :ok, location: @matricula }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @matricula.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matriculas/1 or /matriculas/1.json
  #
  # Exclui uma matrícula existente.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da matrícula a ser excluída.
  #
  # ==== Side Effects
  #
  # * Exclui a matrícula do banco de dados.
  # * Redireciona para a lista de matrículas.
  #
  def destroy
    @matricula.destroy!

    respond_to do |format|
      format.html { redirect_to matriculas_path, status: :see_other, notice: 'Matricula was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_matricula
    @matricula = Matricula.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def matricula_params
    params.require(:matricula).permit(:user_id, :turma_id)
  end
end
