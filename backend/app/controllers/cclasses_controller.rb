class CclassesController < ApplicationController
    
  def index
    turmasCadastradas = Cclass.all
    render json: {
        classes: turmasCadastradas
    }, status: :ok
  end
end