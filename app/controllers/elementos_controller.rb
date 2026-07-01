# Gerencia o CRUD de elementos (questões) de templates de avaliação.
#
# Elementos são as questões que compõem um template. Normalmente são criados e
# editados de forma encadeada via nested attributes no +TemplatesController+; este
# controller expõe as operações individuais de CRUD para cada elemento.
class ElementosController < ApplicationController
  before_action :require_login
  before_action :set_elemento, only: %i[ show edit update destroy ]

  # Lista todos os elementos cadastrados.
  #
  # @return [void]
  def index
    @elementos = Elemento.all
  end

  # Exibe os detalhes de um elemento específico.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de novo elemento.
  #
  # @return [void]
  def new
    @elemento = Elemento.new
  end

  # Exibe o formulário de edição de um elemento existente.
  #
  # @return [void]
  def edit
  end

  # Cria um novo elemento com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste o elemento no banco de dados. Em caso de sucesso, redireciona para a
  #   página do elemento; em caso de falha, re-renderiza o formulário de criação.
  def create
    @elemento = Elemento.new(elemento_params)

    respond_to do |format|
      if @elemento.save
        format.html { redirect_to @elemento, notice: "Elemento was successfully created." }
        format.json { render :show, status: :created, location: @elemento }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @elemento.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de um elemento existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página do elemento; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @elemento.update(elemento_params)
        format.html { redirect_to @elemento, notice: "Elemento was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @elemento }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @elemento.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente um elemento do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de elementos após a exclusão.
  def destroy
    @elemento.destroy!

    respond_to do |format|
      format.html { redirect_to elementos_path, notice: "Elemento was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca o elemento pelo +:id+ da rota e o atribui a +@elemento+.
  #
  # @return [void]
  def set_elemento
    @elemento = Elemento.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de elemento.
  #
  # @return [ActionController::Parameters] parâmetros filtrados do elemento
  def elemento_params
    params.expect(elemento: [ :ordem, :enunciado, :template_id ])
  end
end
