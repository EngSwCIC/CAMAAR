# frozen_string_literal: true

# Controller para gerenciar perguntas.
class PerguntaController < ApplicationController
  before_action :set_perguntum, only: %i[show edit update destroy]

  # GET /pergunta or /pergunta.json
  #
  # Lista todas as perguntas.
  #
  def index
    @pergunta = Perguntum.all
  end

  # GET /pergunta/1 or /pergunta/1.json
  #
  # Exibe os detalhes de uma pergunta específica.
  #
  def show; end

  # GET /pergunta/new
  #
  # Exibe o formulário para a criação de uma nova pergunta.
  #
  def new
    @perguntum = Perguntum.new
  end

  # GET /pergunta/1/edit
  #
  # Exibe o formulário para a edição de uma pergunta existente.
  #
  def edit; end

  # POST /pergunta or /pergunta.json
  #
  # Cria uma nova pergunta com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +perguntum+ - Um hash com os atributos da pergunta.
  #
  # ==== Side Effects
  #
  # * Cria uma nova pergunta no banco de dados.
  # * Redireciona para a página da pergunta em caso de sucesso.
  # * Renderiza o formulário novamente em caso de falha.
  #
  def create
    @perguntum = Perguntum.new(perguntum_params)

    respond_to do |format|
      if @perguntum.save
        format.html { redirect_to @perguntum, notice: 'Perguntum was successfully created.' }
        format.json { render :show, status: :created, location: @perguntum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @perguntum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pergunta/1 or /pergunta/1.json
  #
  # Atualiza uma pergunta existente com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da pergunta a ser atualizada.
  # * +perguntum+ - Um hash com os novos atributos da pergunta.
  #
  # ==== Side Effects
  #
  # * Atualiza a pergunta no banco de dados.
  # * Redireciona para a página da pergunta em caso de sucesso.
  # * Renderiza o formulário de edição novamente em caso de falha.
  #
  def update
    respond_to do |format|
      if @perguntum.update(perguntum_params)
        format.html { redirect_to @perguntum, notice: 'Perguntum was successfully updated.' }
        format.json { render :show, status: :ok, location: @perguntum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @perguntum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pergunta/1 or /pergunta/1.json
  #
  # Exclui uma pergunta existente.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da pergunta a ser excluída.
  #
  # ==== Side Effects
  #
  # * Exclui a pergunta do banco de dados.
  # * Redireciona para a lista de perguntas.
  #
  def destroy
    @perguntum.destroy!

    respond_to do |format|
      format.html { redirect_to pergunta_path, status: :see_other, notice: 'Perguntum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_perguntum
    @perguntum = Perguntum.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def perguntum_params
    params.require(:perguntum).permit(:template_id, :texto, :tipo, :obrigatoria, :titulo, :ordem)
  end
end
