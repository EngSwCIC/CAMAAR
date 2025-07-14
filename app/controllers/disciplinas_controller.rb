# frozen_string_literal: true

# Adicione um comentário de documentação para a classe DisciplinasController.
class DisciplinasController < ApplicationController
  before_action :set_disciplina, only: %i[edit update destroy]

  # GET /disciplinas or /disciplinas.json
  def index
    @disciplinas = Disciplina.all
  end

  # GET /disciplinas/new
  def new
    @disciplina = Disciplina.new
  end

  # GET /disciplinas/1/edit
  def edit; end

  # POST /disciplinas or /disciplinas.json
  def create
    @disciplina = Disciplina.new(disciplina_params)

    respond_to do |format|
      if @disciplina.save
        format.html { redirect_to disciplinas_path, notice: I18n.t('messages.disciplina_created') }
        format.json { render :index, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @disciplina.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /disciplinas/1 or /disciplinas/1.json
  def update
    respond_to do |format|
      if @disciplina.update(disciplina_params)
        format.html { redirect_to disciplinas_path, notice: I18n.t('messages.disciplina_updated') }
        format.json { render :index, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @disciplina.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /disciplinas/1 or /disciplinas/1.json
  def destroy
    @disciplina.destroy!

    respond_to do |format|
      format.html { redirect_to disciplinas_path, status: :see_other, notice: I18n.t('messages.disciplina_destroyed') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_disciplina
    @disciplina = Disciplina.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def disciplina_params
    params.expect(disciplina: %i[nome curso_id])
  end
end
