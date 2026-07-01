# Gerencia o CRUD de campos instanciados em elementos de formulários de avaliação.
#
# +CampoForm+ é a representação de uma opção de resposta dentro de um
# +ElementoForm+ concreto, criada a partir de um +Campo+ de template no momento
# do envio da avaliação. Este controller expõe as operações individuais de CRUD
# sobre essas instâncias.
class CampoFormsController < ApplicationController
  before_action :require_login
  before_action :set_campo_form, only: %i[ show edit update destroy ]

  # Lista todos os campos de formulário cadastrados.
  #
  # @return [void]
  def index
    @campo_forms = CampoForm.all
  end

  # Exibe os detalhes de um campo de formulário específico.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de novo campo de formulário.
  #
  # @return [void]
  def new
    @campo_form = CampoForm.new
  end

  # Exibe o formulário de edição de um campo de formulário existente.
  #
  # @return [void]
  def edit
  end

  # Cria um novo campo de formulário com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste o campo de formulário no banco de dados. Em caso de sucesso,
  #   redireciona para a sua página; em caso de falha, re-renderiza o formulário de criação.
  def create
    @campo_form = CampoForm.new(campo_form_params)

    respond_to do |format|
      if @campo_form.save
        format.html { redirect_to @campo_form, notice: "Campo form was successfully created." }
        format.json { render :show, status: :created, location: @campo_form }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @campo_form.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de um campo de formulário existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página do campo de formulário; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @campo_form.update(campo_form_params)
        format.html { redirect_to @campo_form, notice: "Campo form was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @campo_form }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @campo_form.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente um campo de formulário do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de campos de formulário após a exclusão.
  def destroy
    @campo_form.destroy!

    respond_to do |format|
      format.html { redirect_to campo_forms_path, notice: "Campo form was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca o campo de formulário pelo +:id+ da rota e o atribui a +@campo_form+.
  #
  # @return [void]
  def set_campo_form
    @campo_form = CampoForm.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de campo de formulário.
  #
  # @return [ActionController::Parameters] parâmetros filtrados do campo de formulário
  def campo_form_params
    params.expect(campo_form: [ :ordem, :enunciado, :elemento_form_id ])
  end
end
