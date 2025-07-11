# frozen_string_literal: true

class CursosController < ApplicationController
  before_action :set_curso, only: %i[show edit update destroy]

  # GET /cursos or /cursos.json
  def index
    @cursos = Curso.all
  end

  # GET /cursos/1 or /cursos/1.json
  def show; end

  # GET /cursos/new
  def new
    @curso = Curso.new
  end

  # GET /cursos/1/edit
  def edit; end

  # POST /cursos or /cursos.json
  def create
    @curso = Curso.new(curso_params)

    respond_to do |format|
      if @curso.save
        format.html { redirect_to @curso, notice: 'Curso was successfully created.' }
        format.json { render :show, status: :created, location: @curso }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @curso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cursos/1 or /cursos/1.json
  def update
    respond_to do |format|
      if @curso.update(curso_params)
        format.html { redirect_to @curso, notice: 'Curso was successfully updated.' }
        format.json { render :show, status: :ok, location: @curso }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @curso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cursos/1 or /cursos/1.json
  def destroy
    @curso.destroy!

    respond_to do |format|
      format.html { redirect_to cursos_path, status: :see_other, notice: 'Curso was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_curso
    @curso = Curso.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def curso_params
    params.expect(curso: [:nome])
  end
end
