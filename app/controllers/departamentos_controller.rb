# Gerencia o CRUD de departamentos acadêmicos da instituição.
#
# Departamentos agrupam +Curso+s, +Disciplina+s e +Administrador+es. Não podem
# ser excluídos enquanto possuírem cursos ou disciplinas vinculados. Normalmente
# são criados durante a sincronização com o SIGAA; este controller expõe as
# operações individuais de CRUD para manutenção manual dos registros.
class DepartamentosController < ApplicationController
  before_action :require_login
  before_action :set_departamento, only: %i[ show edit update destroy ]

  # Lista todos os departamentos cadastrados.
  #
  # @return [void]
  def index
    @departamentos = Departamento.all
  end

  # Exibe os detalhes de um departamento específico.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de novo departamento.
  #
  # @return [void]
  def new
    @departamento = Departamento.new
  end

  # Exibe o formulário de edição de um departamento existente.
  #
  # @return [void]
  def edit
  end

  # Cria um novo departamento com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste o departamento no banco de dados. Em caso de sucesso, redireciona para
  #   a sua página; em caso de falha, re-renderiza o formulário de criação.
  def create
    @departamento = Departamento.new(departamento_params)

    respond_to do |format|
      if @departamento.save
        format.html { redirect_to @departamento, notice: "Departamento was successfully created." }
        format.json { render :show, status: :created, location: @departamento }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @departamento.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de um departamento existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página do departamento; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @departamento.update(departamento_params)
        format.html { redirect_to @departamento, notice: "Departamento was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @departamento }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @departamento.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente um departamento do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de departamentos após a exclusão.
  def destroy
    @departamento.destroy!

    respond_to do |format|
      format.html { redirect_to departamentos_path, notice: "Departamento was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca o departamento pelo +:id+ da rota e o atribui a +@departamento+.
  #
  # @return [void]
  def set_departamento
    @departamento = Departamento.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de departamento.
  #
  # @return [ActionController::Parameters] parâmetros filtrados do departamento
  def departamento_params
    params.expect(departamento: [ :codigo, :nome ])
  end
end
