class SurveysController < ApplicationController
  before_action :set_survey, only: %i[ show update destroy ]

  # GET /surveys
  def index
    @surveys = Survey.all

    render  json: @surveys, 
            include: [:survey_questions => {include: [
              multiple_choice: {include: :options},
              likert_scale: {include: :likert_questions}
            ]}]
  end

  # GET /surveys/1
  def show
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
      render :show, status: :created, location: @survey
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /surveys/1
  def update
    if @survey.update(survey_params)
      render :show
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end

  # DELETE /surveys/1
  def destroy
    @survey.destroy
  end

  private
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
