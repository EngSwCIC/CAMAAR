# Gerencia o CRUD de cursos de graduação e pós-graduação.
#
# Cursos pertencem a um +Departamento+ e agrupam +Discente+s. Normalmente são
# criados automaticamente durante a sincronização com o SIGAA; este controller
# expõe as operações individuais de CRUD para manutenção manual dos registros.
class CursosController < ApplicationController
  before_action :require_login
  before_action :set_curso, only: %i[ show edit update destroy ]

  # Lista todos os cursos cadastrados.
  #
  # @return [void]
  def index
    @cursos = Curso.all
  end

  # Exibe os detalhes de um curso específico.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de novo curso.
  #
  # @return [void]
  def new
    @curso = Curso.new
  end

  # Exibe o formulário de edição de um curso existente.
  #
  # @return [void]
  def edit
  end

  # Cria um novo curso com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste o curso no banco de dados. Em caso de sucesso, redireciona para a
  #   sua página; em caso de falha, re-renderiza o formulário de criação.
  def create
    @curso = Curso.new(curso_params)

    respond_to do |format|
      if @curso.save
        format.html { redirect_to @curso, notice: "Curso was successfully created." }
        format.json { render :show, status: :created, location: @curso }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @curso.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de um curso existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página do curso; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @curso.update(curso_params)
        format.html { redirect_to @curso, notice: "Curso was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @curso }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @curso.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente um curso do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de cursos após a exclusão.
  def destroy
    @curso.destroy!

    respond_to do |format|
      format.html { redirect_to cursos_path, notice: "Curso was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca o curso pelo +:id+ da rota e o atribui a +@curso+.
  #
  # @return [void]
  def set_curso
    @curso = Curso.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de curso.
  #
  # @return [ActionController::Parameters] parâmetros filtrados do curso
  def curso_params
    params.expect(curso: [ :codigo, :nome, :departamento_id ])
  end
end
