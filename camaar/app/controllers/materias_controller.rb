class MateriasController < ApplicationController
    def index
        @materias = Materia.all
        render json: @materias
    end
    def show
        @materia = Materia.find(params[:id])
        render json: @materia
    end
end

