# Gerencia o CRUD de formulários de avaliação.
#
# Formulários são instâncias de avaliação enviadas a turmas específicas, geradas
# a partir de templates pelo +AdminController+. Este controller oferece as operações
# básicas de listagem, visualização, criação, edição e exclusão de formulários.
class FormulariosController < ApplicationController
  before_action :require_login
  before_action :set_formulario, only: %i[ show edit update destroy ]

  # Lista todos os formulários cadastrados.
  #
  # @return [void]
  def index
    @formularios = Formulario.all
  end

  # Exibe os detalhes de um formulário específico.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de novo formulário.
  #
  # @return [void]
  def new
    @formulario = Formulario.new
  end

  # Exibe o formulário de edição de um formulário existente.
  #
  # @return [void]
  def edit
  end

  # Cria um novo formulário com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste o formulário no banco de dados. Em caso de sucesso, redireciona para
  #   a página do formulário; em caso de falha, re-renderiza o formulário de criação.
  def create
    @formulario = Formulario.new(formulario_params)

    respond_to do |format|
      if @formulario.save
        format.html { redirect_to @formulario, notice: "Formulario was successfully created." }
        format.json { render :show, status: :created, location: @formulario }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @formulario.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de um formulário existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página do formulário; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @formulario.update(formulario_params)
        format.html { redirect_to @formulario, notice: "Formulario was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @formulario }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @formulario.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente um formulário do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de formulários após a exclusão.
  def destroy
    @formulario.destroy!

    respond_to do |format|
      format.html { redirect_to formularios_path, notice: "Formulario was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca o formulário pelo +:id+ da rota e o atribui a +@formulario+.
  #
  # @return [void]
  def set_formulario
    @formulario = Formulario.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de formulário.
  #
  # @return [ActionController::Parameters] parâmetros filtrados do formulário
  def formulario_params
    params.expect(formulario: [ :turma_id ])
  end
end
