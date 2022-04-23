class SurveysController < ApplicationController
  before_action :set_survey, only: %i[ show update destroy ]
  before_action :set_surveys, only: %i[ index open ]

  # GET /surveys
  def index
    render  json: @surveys, 
            include: [:survey_questions => {include: [
              multiple_choice: {include: :options},
              likert_scale: {include: :likert_questions}
            ]}]
  end

  def open 
    @surveys = @surveys.select do |survey|
      survey.is_expired? == false
    end

    index
  end

  # GET /surveys/1
  def show(status = nil)
    render  json: @survey, 
            include: [:survey_questions => {include: [
              multiple_choice: {include: :options},
              likert_scale: {include: :likert_questions}
            ]}]
  end

  # POST /surveys
  def create
    @survey = Survey.new(survey_params)

    if @survey.save
      show
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /surveys/1
  def update
    if @survey.update(survey_params)
      show
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end

  # DELETE /surveys/1
  def destroy
    @survey.destroy
  end

  private

    def set_surveys
      @surveys = Survey.all
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def survey_params
      params.require(:survey).permit(
        :name,
        :description,
        :expiration_date,
        :semester,
        survey_questions_attributes: [
          :question,
          :question_type,
          :optional,
          multiple_choice_attributes: [ options_attributes: [:option] ],
          likert_scale_attributes: [ likert_questions_attributes: [:question] ]
        ])
    end
end
