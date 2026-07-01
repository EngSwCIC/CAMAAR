# Gerencia o CRUD de disciplinas ofertadas pelos departamentos.
#
# Disciplinas pertencem a um +Departamento+ e possuem múltiplas +Turma+s (uma
# por semestre/oferta). Normalmente são importadas via sincronização com o SIGAA;
# este controller expõe as operações individuais de CRUD para manutenção manual
# dos registros.
class DisciplinasController < ApplicationController
  before_action :require_login
  before_action :set_disciplina, only: %i[ show edit update destroy ]

  # Lista todas as disciplinas cadastradas.
  #
  # @return [void]
  def index
    @disciplinas = Disciplina.all
  end

  # Exibe os detalhes de uma disciplina específica.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de nova disciplina.
  #
  # @return [void]
  def new
    @disciplina = Disciplina.new
  end

  # Exibe o formulário de edição de uma disciplina existente.
  #
  # @return [void]
  def edit
  end

  # Cria uma nova disciplina com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste a disciplina no banco de dados. Em caso de sucesso, redireciona para
  #   a sua página; em caso de falha, re-renderiza o formulário de criação.
  def create
    @disciplina = Disciplina.new(disciplina_params)

    respond_to do |format|
      if @disciplina.save
        format.html { redirect_to @disciplina, notice: "Disciplina was successfully created." }
        format.json { render :show, status: :created, location: @disciplina }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @disciplina.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de uma disciplina existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página da disciplina; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @disciplina.update(disciplina_params)
        format.html { redirect_to @disciplina, notice: "Disciplina was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @disciplina }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @disciplina.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente uma disciplina do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de disciplinas após a exclusão.
  def destroy
    @disciplina.destroy!

    respond_to do |format|
      format.html { redirect_to disciplinas_path, notice: "Disciplina was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca a disciplina pelo +:id+ da rota e a atribui a +@disciplina+.
  #
  # @return [void]
  def set_disciplina
    @disciplina = Disciplina.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de disciplina.
  #
  # @return [ActionController::Parameters] parâmetros filtrados da disciplina
  def disciplina_params
    params.expect(disciplina: [ :codigo, :nome, :departamento_id ])
  end
end
