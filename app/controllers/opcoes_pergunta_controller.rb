# frozen_string_literal: true

# Controller para gerenciar opções de perguntas.
class OpcoesPerguntaController < ApplicationController
  before_action :set_opcoes_perguntum, only: %i[show edit update destroy]

  # GET /opcoes_pergunta or /opcoes_pergunta.json
  #
  # Lista todas as opções de perguntas.
  #
  def index
    @opcoes_pergunta = OpcoesPerguntum.all
  end

  # GET /opcoes_pergunta/1 or /opcoes_pergunta/1.json
  #
  # Exibe os detalhes de uma opção de pergunta específica.
  #
  def show; end

  # GET /opcoes_pergunta/new
  #
  # Exibe o formulário para a criação de uma nova opção de pergunta.
  #
  def new
    @opcoes_perguntum = OpcoesPerguntum.new
  end

  # GET /opcoes_pergunta/1/edit
  #
  # Exibe o formulário para a edição de uma opção de pergunta existente.
  #
  def edit; end

  # POST /opcoes_pergunta or /opcoes_pergunta.json
  #
  # Cria uma nova opção de pergunta com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +opcoes_perguntum+ - Um hash com os atributos da opção de pergunta.
  #
  # ==== Side Effects
  #
  # * Cria uma nova opção de pergunta no banco de dados.
  # * Redireciona para a página da opção de pergunta em caso de sucesso.
  # * Renderiza o formulário novamente em caso de falha.
  #
  def create
    @opcoes_perguntum = OpcoesPerguntum.new(opcoes_perguntum_params)

    respond_to do |format|
      if @opcoes_perguntum.save
        format.html { redirect_to @opcoes_perguntum, notice: 'Opcoes perguntum was successfully created.' }
        format.json { render :show, status: :created, location: @opcoes_perguntum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @opcoes_perguntum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /opcoes_pergunta/1 or /opcoes_pergunta/1.json
  #
  # Atualiza uma opção de pergunta existente com os parâmetros fornecidos.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da opção de pergunta a ser atualizada.
  # * +opcoes_perguntum+ - Um hash com os novos atributos da opção de pergunta.
  #
  # ==== Side Effects
  #
  # * Atualiza a opção de pergunta no banco de dados.
  # * Redireciona para a página da opção de pergunta em caso de sucesso.
  # * Renderiza o formulário de edição novamente em caso de falha.
  #
  def update
    respond_to do |format|
      if @opcoes_perguntum.update(opcoes_perguntum_params)
        format.html { redirect_to @opcoes_perguntum, notice: 'Opcoes perguntum was successfully updated.' }
        format.json { render :show, status: :ok, location: @opcoes_perguntum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @opcoes_perguntum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /opcoes_pergunta/1 or /opcoes_pergunta/1.json
  #
  # Exclui uma opção de pergunta existente.
  #
  # ==== Attributes
  #
  # * +id+ - O ID da opção de pergunta a ser excluída.
  #
  # ==== Side Effects
  #
  # * Exclui a opção de pergunta do banco de dados.
  # * Redireciona para a lista de opções de perguntas.
  #
  def destroy
    @opcoes_perguntum.destroy!

    respond_to do |format|
      format.html do
        redirect_to opcoes_pergunta_path, status: :see_other, notice: 'Opcoes perguntum was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_opcoes_perguntum
    @opcoes_perguntum = OpcoesPerguntum.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def opcoes_perguntum_params
    params.require(:opcoes_perguntum).permit(:pergunta_id, :texto)
  end
end
