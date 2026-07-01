# Gerencia o CRUD de respostas completas submetidas por usuários a formulários.
#
# Uma +RespostaForm+ representa a submissão de um usuário a um +Formulario+
# inteiro. O fluxo principal de submissão é tratado pelo +UsuariosController+;
# este controller expõe as operações individuais de CRUD para administração direta
# dos registros de resposta.
class RespostaFormsController < ApplicationController
  before_action :require_login
  before_action :set_resposta_form, only: %i[ show edit update destroy ]

  # Lista todas as respostas de formulário cadastradas.
  #
  # @return [void]
  def index
    @resposta_forms = RespostaForm.all
  end

  # Exibe os detalhes de uma resposta de formulário específica.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de nova resposta de formulário.
  #
  # @return [void]
  def new
    @resposta_form = RespostaForm.new
  end

  # Exibe o formulário de edição de uma resposta de formulário existente.
  #
  # @return [void]
  def edit
  end

  # Cria uma nova resposta de formulário com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste a resposta no banco de dados. Em caso de sucesso, redireciona para a
  #   sua página; em caso de falha, re-renderiza o formulário de criação.
  def create
    @resposta_form = RespostaForm.new(resposta_form_params)

    respond_to do |format|
      if @resposta_form.save
        format.html { redirect_to @resposta_form, notice: "Resposta form was successfully created." }
        format.json { render :show, status: :created, location: @resposta_form }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @resposta_form.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de uma resposta de formulário existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página da resposta; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @resposta_form.update(resposta_form_params)
        format.html { redirect_to @resposta_form, notice: "Resposta form was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @resposta_form }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @resposta_form.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente uma resposta de formulário do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de respostas após a exclusão.
  def destroy
    @resposta_form.destroy!

    respond_to do |format|
      format.html { redirect_to resposta_forms_path, notice: "Resposta form was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca a resposta de formulário pelo +:id+ da rota e a atribui a +@resposta_form+.
  #
  # @return [void]
  def set_resposta_form
    @resposta_form = RespostaForm.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de resposta de formulário.
  #
  # @return [ActionController::Parameters] parâmetros filtrados da resposta de formulário
  def resposta_form_params
    params.expect(resposta_form: [ :data_submissao, :formulario_id, :usuario_id ])
  end
end
