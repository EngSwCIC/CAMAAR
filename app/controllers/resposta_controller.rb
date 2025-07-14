# frozen_string_literal: true

# Adicione um comentário de documentação para a classe RespostaController.
class RespostaController < ApplicationController
  before_action :set_respostum, only: %i[show edit update destroy]

  # GET /resposta or /resposta.json
  def index
    @resposta = Respostum.all
  end

  # GET /resposta/1 or /resposta/1.json
  def show; end

  # GET /resposta/new
  def new
    @respostum = Respostum.new
  end

  # GET /resposta/1/edit
  def edit; end

  # POST /resposta or /resposta.json
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
    @respostum = Respostum.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def respostum_params
    params.expect(respostum: %i[formulario_id pergunta_id opcao_id resposta_texto turma_id uuid_anonimo])
  end
end
