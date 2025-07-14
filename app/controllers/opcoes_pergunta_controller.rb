# frozen_string_literal: true

# Adicione um comentário de documentação para a classe OpcoesPerguntaController.
class OpcoesPerguntaController < ApplicationController
  before_action :set_opcoes_perguntum, only: %i[show edit update destroy]

  # GET /opcoes_pergunta or /opcoes_pergunta.json
  def index
    @opcoes_pergunta = OpcoesPerguntum.all
  end

  # GET /opcoes_pergunta/1 or /opcoes_pergunta/1.json
  def show; end

  # GET /opcoes_pergunta/new
  def new
    @opcoes_perguntum = OpcoesPerguntum.new
  end

  # GET /opcoes_pergunta/1/edit
  def edit; end

  # POST /opcoes_pergunta or /opcoes_pergunta.json
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
    @opcoes_perguntum = OpcoesPerguntum.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def opcoes_perguntum_params
    params.expect(opcoes_perguntum: %i[pergunta_id texto])
  end
end
