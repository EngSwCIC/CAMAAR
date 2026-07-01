# Gerencia o CRUD de campos (opções de resposta) de elementos de template.
#
# Campos definem as opções disponíveis para resposta em um elemento, bem como o
# tipo da questão (texto livre, múltipla escolha etc.). Normalmente são gerenciados
# via nested attributes no +TemplatesController+; este controller expõe as operações
# individuais de CRUD.
class CamposController < ApplicationController
  before_action :require_login
  before_action :set_campo, only: %i[ show edit update destroy ]

  # Lista todos os campos cadastrados.
  #
  # @return [void]
  def index
    @campos = Campo.all
  end

  # Exibe os detalhes de um campo específico.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de novo campo.
  #
  # @return [void]
  def new
    @campo = Campo.new
  end

  # Exibe o formulário de edição de um campo existente.
  #
  # @return [void]
  def edit
  end

  # Cria um novo campo com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste o campo no banco de dados. Em caso de sucesso, redireciona para a
  #   página do campo; em caso de falha, re-renderiza o formulário de criação.
  def create
    @campo = Campo.new(campo_params)

    respond_to do |format|
      if @campo.save
        format.html { redirect_to @campo, notice: "Campo was successfully created." }
        format.json { render :show, status: :created, location: @campo }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @campo.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de um campo existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página do campo; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @campo.update(campo_params)
        format.html { redirect_to @campo, notice: "Campo was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @campo }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @campo.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente um campo do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de campos após a exclusão.
  def destroy
    @campo.destroy!

    respond_to do |format|
      format.html { redirect_to campos_path, notice: "Campo was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca o campo pelo +:id+ da rota e o atribui a +@campo+.
  #
  # @return [void]
  def set_campo
    @campo = Campo.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de campo.
  #
  # @return [ActionController::Parameters] parâmetros filtrados do campo
  def campo_params
    params.expect(campo: [ :ordem, :enunciado, :tipo_elemento, :elemento_id ])
  end
end
