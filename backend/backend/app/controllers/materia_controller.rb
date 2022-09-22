class MateriaController < ApplicationController
  before_action :authenticate_user!
  before_action :set_materia, only: %i[ show update destroy ]

  # GET /materia
  def index
    @materias = Materia.all

    render json: @materias
  end

  # GET /materia/1
  def show
    render json: @materia
  end

  # POST /materia
  def create
    @materia = Materia.new(materia_params)

    if @materia.save
      render json: @materia, status: :created, location: @materia
    else
      render json: @materia.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /materia/1
  def update
    if @materia.update(materia_params)
      render json: @materia
    else
      render json: @materia.errors, status: :unprocessable_entity
    end
  end

  # DELETE /materia/1
  def destroy
    @materia.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_materia
      @materia = Materia.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def materia_params
      params.require(:materia).permit(:codigo, :nome)
    end
end
