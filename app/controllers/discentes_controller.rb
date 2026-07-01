# Gerencia o CRUD de discentes (alunos) cadastrados no sistema.
#
# Discentes são usuários com perfil de aluno, vinculados a um +Curso+ e a uma
# ou mais +Turma+s. Normalmente são importados via +AdminController#sincronizar_sigaa+;
# este controller expõe as operações individuais de CRUD para manutenção manual
# dos registros.
class DiscentesController < ApplicationController
  before_action :require_login
  before_action :set_discente, only: %i[ show edit update destroy ]

  # Lista todos os discentes cadastrados.
  #
  # @return [void]
  def index
    @discentes = Discente.all
  end

  # Exibe os detalhes de um discente específico.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de novo discente.
  #
  # @return [void]
  def new
    @discente = Discente.new
  end

  # Exibe o formulário de edição de um discente existente.
  #
  # @return [void]
  def edit
  end

  # Cria um novo discente com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste o discente no banco de dados. Em caso de sucesso, redireciona para a
  #   sua página; em caso de falha, re-renderiza o formulário de criação.
  def create
    @discente = Discente.new(discente_params)

    respond_to do |format|
      if @discente.save
        format.html { redirect_to @discente, notice: "Discente was successfully created." }
        format.json { render :show, status: :created, location: @discente }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @discente.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de um discente existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página do discente; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @discente.update(discente_params)
        format.html { redirect_to @discente, notice: "Discente was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @discente }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @discente.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente um discente do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de discentes após a exclusão.
  def destroy
    @discente.destroy!

    respond_to do |format|
      format.html { redirect_to discentes_path, notice: "Discente was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca o discente pelo +:id+ da rota e o atribui a +@discente+.
  #
  # @return [void]
  def set_discente
    @discente = Discente.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de discente.
  #
  # @return [ActionController::Parameters] parâmetros filtrados do discente
  def discente_params
    params.expect(discente: [ :matricula, :email, :nome, :formacao, :curso_id ])
  end
end
