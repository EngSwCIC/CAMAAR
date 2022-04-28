class SurveysController < ApplicationController
  before_action :set_survey, only: %i[ show update destroy ]
  before_action :set_surveys, only: %i[ index open ]

  # GET /surveys
  def index
    render json: @surveys
  end

  def open 
    @surveys = @surveys.select do |survey|
      survey.is_expired? == false
    end

    index
  end

  # GET /surveys/1
  def show(status = nil)
    render json: @survey
  end

  private

    def set_surveys
      @surveys = Survey.all
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end
end
