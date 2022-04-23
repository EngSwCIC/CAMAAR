class SurveysController < ApplicationController

  def index
    filter = request.query_parameters[:filter]

    @surveys = if params[:filter]
      if params[:filter][:code] || params[:filter][:cclass]
        Survey.where(filter)
      end
    else
      Survey.all
    end

    render json: SurveysSerializer.new(@surveys).serialized_json
  end

  def create
  end

  def answer_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:survey])
    # params.require(:survey).permit()
  end
end
