class SurveysController < ApplicationController

  def index
    @surveys = Survey.all
    render json: SurveysSerializer.new(@surveys).serialized_json
  end

  def create
    @survey = Survey.create(params[:survey])
  end

  def surveys_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:survey])
    # params.require(:survey).permit()
  end
end
