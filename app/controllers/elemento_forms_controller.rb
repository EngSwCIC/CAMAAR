# Gerencia o CRUD de elementos instanciados em formulários de avaliação.
#
# +ElementoForm+ é a representação de uma questão dentro de um +Formulario+
# concreto, criada a partir de um +Elemento+ de template no momento do envio da
# avaliação. Este controller expõe as operações individuais de CRUD sobre essas
# instâncias.
class ElementoFormsController < ApplicationController
  before_action :require_login
  before_action :set_elemento_form, only: %i[ show edit update destroy ]

  # Lista todos os elementos de formulário cadastrados.
  #
  # @return [void]
  def index
    @elemento_forms = ElementoForm.all
  end

  # Exibe os detalhes de um elemento de formulário específico.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de novo elemento de formulário.
  #
  # @return [void]
  def new
    @elemento_form = ElementoForm.new
  end

  # Exibe o formulário de edição de um elemento de formulário existente.
  #
  # @return [void]
  def edit
  end

  # Cria um novo elemento de formulário com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste o elemento de formulário no banco de dados. Em caso de sucesso,
  #   redireciona para a sua página; em caso de falha, re-renderiza o formulário de criação.
  def create
    @elemento_form = ElementoForm.new(elemento_form_params)

    respond_to do |format|
      if @elemento_form.save
        format.html { redirect_to @elemento_form, notice: "Elemento form was successfully created." }
        format.json { render :show, status: :created, location: @elemento_form }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @elemento_form.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de um elemento de formulário existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página do elemento de formulário; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @elemento_form.update(elemento_form_params)
        format.html { redirect_to @elemento_form, notice: "Elemento form was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @elemento_form }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @elemento_form.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente um elemento de formulário do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de elementos de formulário após a exclusão.
  def destroy
    @elemento_form.destroy!

    respond_to do |format|
      format.html { redirect_to elemento_forms_path, notice: "Elemento form was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca o elemento de formulário pelo +:id+ da rota e o atribui a +@elemento_form+.
  #
  # @return [void]
  def set_elemento_form
    @elemento_form = ElementoForm.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de elemento de formulário.
  #
  # @return [ActionController::Parameters] parâmetros filtrados do elemento de formulário
  def elemento_form_params
    params.expect(elemento_form: [ :ordem, :enunciado, :formulario_id ])
  end
end
