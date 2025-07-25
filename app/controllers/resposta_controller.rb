# frozen_string_literal: true

# Controller para gerenciar respostas.
class RespostaController < ApplicationController
  before_action :set_respostum, only: %i[show edit update destroy]

  # GET /resposta or /resposta.json
  #
  # Lista todas as respostas.
  #
  def index
    @resposta = Respostum.all
  end

  # GET /resposta/1 or /resposta/1.json
  #
  # Exibe os detalhes de uma resposta específica.
  #
  def show; end

  # GET /resposta/new
  #
  # Exibe o formulário para a criação de uma nova resposta.
  #
  def new
    @respostum = Respostum.new
  end

  # GET /resposta/1/edit
  #
  # Exibe o formulário para a edição de uma resposta existente.
  #
  def edit; end

  # POST /resposta or /resposta.json
  #
  # Cria uma nova resposta com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +respostum+ - Um hash com os atributos da resposta.
  #
  # ==== Side Effects
  #
  # * Cria uma nova resposta no banco de dados.
  # * Redireciona para a página da resposta em caso de sucesso.
  # * Renderiza o formulário novamente em caso de falha.
  #
  def create
    @respostum = Respostum.new(respostum_params)

    respond_to do |format|
      if @respostum.save
        format.html { redirect_to @respostum, notice: 'Respostum was successfully created.' }
        format.json { render :show, status: :created, location: @respostum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @respostum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resposta/1 or /resposta/1.json
  #
  # Atualiza uma resposta existente com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da resposta a ser atualizada.
  # * +respostum+ - Um hash com os novos atributos da resposta.
  #
  # ==== Side Effects
  #
  # * Atualiza a resposta no banco de dados.
  # * Redireciona para a página da resposta em caso de sucesso.
  # * Renderiza o formulário de edição novamente em caso de falha.
  #
  def update
    respond_to do |format|
      if @respostum.update(respostum_params)
        format.html { redirect_to @respostum, notice: 'Respostum was successfully updated.' }
        format.json { render :show, status: :ok, location: @respostum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @respostum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resposta/1 or /resposta/1.json
  #
  # Exclui uma resposta existente.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da resposta a ser excluída.
  #
  # ==== Side Effects
  #
  # * Exclui a resposta do banco de dados.
  # * Redireciona para a lista de respostas.
  #
  def destroy
    @respostum.destroy!

    respond_to do |format|
      format.html { redirect_to resposta_path, status: :see_other, notice: 'Respostum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_respostum
    @respostum = Respostum.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def respostum_params
    params.require(:respostum).permit(:formulario_id, :pergunta_id, :opcao_id, :resposta_texto, :turma_id,
                                      :uuid_anonimo)
  end
end
