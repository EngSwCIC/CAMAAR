class CclassesController < ApplicationController
    def index
        @cclasses = Cclass.all
        render json: CclassesSerializer.new(@cclasses).serialized_json
      end
    
      def create
        @cclass = Cclass.create(params[:cclass])
      end
    
      def cclasses_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:option])
        # params.require(:cclass).permit()
      end
    end