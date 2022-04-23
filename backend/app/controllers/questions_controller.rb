class QuestionsController < ApplicationController
    def index
        filter = request.query_parameters[:filter]
    
        @questions = if params[:filter]
          if params[:filter][:code]
            Question.where(filter)
          end
        else
          Question.all
        end
    
        render json: QuestionsSerializer.new(@questions).serialized_json
      end

      def create
      end
    
      def questions_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:question])
        # params.require(:survey).permit()
      end

end
