# Gerencia o CRUD de docentes (professores) cadastrados no sistema.
#
# Docentes são usuários com perfil de professor, vinculados a uma ou mais +Turma+s
# e a um +Departamento+. Normalmente são importados via +AdminController#sincronizar_sigaa+;
# este controller expõe as operações individuais de CRUD para manutenção manual
# dos registros.
class DocentesController < ApplicationController
  before_action :require_login
  before_action :set_docente, only: %i[ show edit update destroy ]

  # Lista todos os docentes cadastrados.
  #
  # @return [void]
  def index
    @docentes = Docente.all
  end

  # Exibe os detalhes de um docente específico.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de novo docente.
  #
  # @return [void]
  def new
    @docente = Docente.new
  end

  # Exibe o formulário de edição de um docente existente.
  #
  # @return [void]
  def edit
  end

  # Cria um novo docente com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste o docente no banco de dados. Em caso de sucesso, redireciona para a
  #   sua página; em caso de falha, re-renderiza o formulário de criação.
  def create
    @docente = Docente.new(docente_params)

    respond_to do |format|
      if @docente.save
        format.html { redirect_to @docente, notice: "Docente was successfully created." }
        format.json { render :show, status: :created, location: @docente }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @docente.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de um docente existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página do docente; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @docente.update(docente_params)
        format.html { redirect_to @docente, notice: "Docente was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @docente }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @docente.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente um docente do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de docentes após a exclusão.
  def destroy
    @docente.destroy!

    respond_to do |format|
      format.html { redirect_to docentes_path, notice: "Docente was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca o docente pelo +:id+ da rota e o atribui a +@docente+.
  #
  # @return [void]
  def set_docente
    @docente = Docente.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de docente.
  #
  # @return [ActionController::Parameters] parâmetros filtrados do docente
  def docente_params
    params.expect(docente: [ :matricula, :email, :nome, :formacao ])
  end
end
