# Gerencia o CRUD de respostas individuais a questões de formulários de avaliação.
#
# Uma +RespostaElem+ representa a resposta de um usuário a um +ElementoForm+
# específico, vinculada a uma +RespostaForm+. O fluxo principal de criação ocorre
# via +UsuariosController#submeter_resposta+; este controller expõe as operações
# individuais de CRUD para administração direta dos registros.
class RespostaElemsController < ApplicationController
  before_action :require_login
  before_action :set_resposta_elem, only: %i[ show edit update destroy ]

  # Lista todas as respostas de elemento cadastradas.
  #
  # @return [void]
  def index
    @resposta_elems = RespostaElem.all
  end

  # Exibe os detalhes de uma resposta de elemento específica.
  #
  # @return [void]
  def show
  end

  # Exibe o formulário de criação de nova resposta de elemento.
  #
  # @return [void]
  def new
    @resposta_elem = RespostaElem.new
  end

  # Exibe o formulário de edição de uma resposta de elemento existente.
  #
  # @return [void]
  def edit
  end

  # Cria uma nova resposta de elemento com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste a resposta no banco de dados. Em caso de sucesso, redireciona para a
  #   sua página; em caso de falha, re-renderiza o formulário de criação.
  def create
    @resposta_elem = RespostaElem.new(resposta_elem_params)

    respond_to do |format|
      if @resposta_elem.save
        format.html { redirect_to @resposta_elem, notice: "Resposta elem was successfully created." }
        format.json { render :show, status: :created, location: @resposta_elem }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @resposta_elem.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de uma resposta de elemento existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados. Em caso de sucesso, redireciona para
  #   a página da resposta; em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @resposta_elem.update(resposta_elem_params)
        format.html { redirect_to @resposta_elem, notice: "Resposta elem was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @resposta_elem }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @resposta_elem.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente uma resposta de elemento do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de respostas de elemento após a exclusão.
  def destroy
    @resposta_elem.destroy!

    respond_to do |format|
      format.html { redirect_to resposta_elems_path, notice: "Resposta elem was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca a resposta de elemento pelo +:id+ da rota e a atribui a +@resposta_elem+.
  #
  # @return [void]
  def set_resposta_elem
    @resposta_elem = RespostaElem.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de resposta de elemento.
  #
  # @return [ActionController::Parameters] parâmetros filtrados da resposta de elemento
  def resposta_elem_params
    params.expect(resposta_elem: [ :texto_resposta, :resposta_form_id, :elemento_form_id, :campo_form_id ])
  end
end
