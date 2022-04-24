class OptionsController < ApplicationController
  

  def index
    @options = Option.all
    render json: OptionsSerializer.new(@options).serialized_json
  end

  def create
    @option = Option.create(params[:option])
  end

  def options_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:option])
    # params.require(:survey).permit()
  end
end
