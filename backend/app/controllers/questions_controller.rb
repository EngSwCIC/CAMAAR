class QuestionsController < ApplicationController
    def index
      def index
        @questions = Question.all
        render json: QuestionSerializer.new(@questions).serialized_json
      end
    
      def create
        @question = Question.create(params[:question])
      end
    
      def questions_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:question])
        # params.require(:survey).permit()
      end
    end
  end
    