class TurmasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_turma, only: %i[show edit update destroy]
  
  # GET /turmas or /turmas.json
  def index
    @turmas = current_user.turmas
  end
  
  # GET /turmas/1 or /turmas/1.json
  def show
  end
  
  # GET /turmas/new
  def new
    @turma = current_user.turmas.build
  end
  
  # GET /turmas/1/edit
  def edit
  end
  
  # POST /turmas or /turmas.json
  def create
    @turma = current_user.turmas.build(turma_params)

    respond_to do |format|
      if @turma.save
        format.html { redirect_to @turma, notice: "Turma was successfully created." }
        format.json { render :show, status: :created, location: @turma }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @turma.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /turmas/1 or /turmas/1.json
  def update
    respond_to do |format|
      if @turma.update(turma_params)
        format.html { redirect_to @turma, notice: "Turma was successfully updated." }
        format.json { render :show, status: :ok, location: @turma }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @turma.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /turmas/1 or /turmas/1.json
  def destroy
    @turma.destroy
    respond_to do |format|
      format.html { redirect_to turmas_url, notice: "Turma was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_turma
    @turma = current_user.turmas.find(params[:id])
  end
  
  def turma_params
    params.require(:turma).permit(:classCode, :semestre, :materia, :id_professor)
  end
end
