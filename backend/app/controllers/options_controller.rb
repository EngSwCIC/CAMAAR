class OptionsController < ApplicationController
  
    def index
        filter = request.query_parameters[:filter]
    
        @options = if params[:filter]
          if params[:filter][:code]
            Option.where(filter)
          end
        else
          Option.all
        end
    
        render json: OptionsSerializer.new(@options).serialized_json
     
      end

      def create
      end
    
      def options_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:option])
        # params.require(:option).permit()
      end

end
