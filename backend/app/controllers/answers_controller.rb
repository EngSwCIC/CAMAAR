class AnswersController < ApplicationController
    def index
      @answers = Answer.all
      render json: AnswersSerializer.new(@answers).serialized_json
    end
  
    def create
      @answer = Answer.create(params[:answer])
    end
  
    def answers_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:answer])
      # params.require(:survey).permit()
    end
  end
  