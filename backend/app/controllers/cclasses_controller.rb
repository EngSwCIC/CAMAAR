class CclassesController < ApplicationController

    def index
      filter = request.query_parameters[:filter]

      @cclasses = Cclass.all

      render json: CclassesSerializer.new(@cclasses).serialized_json
    end

end
