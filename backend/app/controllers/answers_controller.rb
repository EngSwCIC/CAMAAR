class AnswersController < ApplicationController
    def index
        filter = request.query_parameters[:filter]
    
        @answers = if params[:filter]
          if params[:filter][:code]
            Answer.where(filter)
          end
        else
          Answer.all
        end
    
        render json: AnswersSerializer.new(@answers).serialized_json
      end

      def create
      end

      def answers_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:answer])
        # params.require(:survey).permit()
      end

end
