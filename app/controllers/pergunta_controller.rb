# frozen_string_literal: true

# Adicione um comentário de documentação para a classe PerguntaController.
class PerguntaController < ApplicationController
  before_action :set_perguntum, only: %i[show edit update destroy]

  # GET /pergunta or /pergunta.json
  def index
    @pergunta = Perguntum.all
  end

  # GET /pergunta/1 or /pergunta/1.json
  def show; end

  # GET /pergunta/new
  def new
    @perguntum = Perguntum.new
  end

  # GET /pergunta/1/edit
  def edit; end

  # POST /pergunta or /pergunta.json
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
    @perguntum = Perguntum.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def perguntum_params
    params.expect(perguntum: %i[template_id texto tipo obrigatoria])
  end
end
