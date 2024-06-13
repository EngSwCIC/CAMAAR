class MateriasController < ApplicationController
  before_action :set_materia, only: %i[ show edit update destroy ]

  # GET /materias or /materias.json
  def index
    @materias = Materia.all
  end

  # GET /materias/1 or /materias/1.json
  def show
  end

  # GET /materias/new
  def new
    @materia = Materia.new
  end

  # GET /materias/1/edit
  def edit
  end

  # POST /materias or /materias.json
  def create
    @materia = Materia.new(materia_params)

    respond_to do |format|
      if @materia.save
        format.html { redirect_to materia_url(@materia), notice: "Materia was successfully created." }
        format.json { render :show, status: :created, location: @materia }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @materia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /materias/1 or /materias/1.json
  def update
    respond_to do |format|
      if @materia.update(materia_params)
        format.html { redirect_to materia_url(@materia), notice: "Materia was successfully updated." }
        format.json { render :show, status: :ok, location: @materia }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @materia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /materias/1 or /materias/1.json
  def destroy
    @materia.destroy!

    respond_to do |format|
      format.html { redirect_to materias_url, notice: "Materia was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_materia
      @materia = Materia.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def materia_params
      params.require(:materia).permit(:code, :nome)
    end
end
