# Gerencia o CRUD de turmas.
#
# Turmas representam a oferta de uma disciplina em um semestre, agrupando docentes
# e discentes. Este controller oferece as operações básicas de listagem, visualização,
# criação, edição e exclusão de turmas.
class TurmasController < ApplicationController
  before_action :require_login
  before_action :set_turma, only: %i[ show edit update destroy ]

  # Lista todas as turmas cadastradas.
  #
  # @return [void]
  def index
    @turmas = Turma.all
  end

  # Exibe os detalhes de uma turma específica.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de nova turma.
  #
  # @return [void]
  def new
    @turma = Turma.new
  end

  # Exibe o formulário de edição de uma turma existente.
  #
  # @return [void]
  def edit
  end

  # Cria uma nova turma com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste a turma no banco de dados. Em caso de sucesso, redireciona para a
  #   página da turma; em caso de falha, re-renderiza o formulário de criação.
  def create
    @turma = Turma.new(turma_params)

    respond_to do |format|
      if @turma.save
        format.html { redirect_to @turma, notice: "Turma was successfully created." }
        format.json { render :show, status: :created, location: @turma }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @turma.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de uma turma existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página da turma; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @turma.update(turma_params)
        format.html { redirect_to @turma, notice: "Turma was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @turma }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @turma.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente uma turma do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de turmas após a exclusão.
  def destroy
    @turma.destroy!

    respond_to do |format|
      format.html { redirect_to turmas_path, notice: "Turma was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca a turma pelo +:id+ da rota e a atribui a +@turma+.
  #
  # @return [void]
  def set_turma
    @turma = Turma.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de turma.
  #
  # @return [ActionController::Parameters] parâmetros filtrados da turma
  def turma_params
    params.expect(turma: [ :numero_da_turma, :semestre, :horario, :disciplina_id ])
  end
end
