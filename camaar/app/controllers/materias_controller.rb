class MateriasController < ApplicationController
    def index
        @materias = Materia.all

        respond_to do |format|
            format.html
            format.json { render json: @materias }
        end
    end
    def show
        @materia = Materia.find(params[:id])

        respond_to do |format|
            format.html
            format.json { render json: @materia }
        end
    end
end

