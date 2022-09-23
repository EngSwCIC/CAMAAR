class SubjectsController < ApplicationController
  def index
    ##
    # Retrona todos os dados do banco de dados

    @subjects = Subject.all
    render json: @subjects, status: :ok
  end

  def show
    ##
    # Retorna apenas o dado de id :id

    @subject = Subject.find(params[:id])
    render json: @subject, status: :ok
  end
end
