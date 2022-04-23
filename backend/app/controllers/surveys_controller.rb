class SurveysController < ApplicationController

  def index
    filter = request.query_parameters[:filter]

    @surveys = if params[:filter]
      if params[:filter][:code]
        Survey.where(filter)
      end
    else
      Survey.all
    end

    render json: SurveysSerializer.new(@surveys).serialized_json
  end

  def create
    @survey = Survey.new(params[:survey])
    if @survey.save
      redirect_to @survey
    else
      render "new"
    end
  end

  def surveys_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:survey])
    # params.require(:survey).permit()
  end
end
