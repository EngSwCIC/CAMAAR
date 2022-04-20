class SurveyQuestionsController < ApplicationController
  before_action :set_survey_question, only: %i[ show update destroy ]

  # GET /survey_questions
  def index
    @survey_questions = SurveyQuestion.all

    render json: @survey_questions
  end

  # GET /survey_questions/1
  def show
    render json: @survey_question
  end

  # POST /survey_questions
  def create
    @survey_question = SurveyQuestion.new(survey_question_params)

    if @survey_question.save
      render json: @survey_question, status: :created, location: @survey_question
    else
      render json: @survey_question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /survey_questions/1
  def update
    if @survey_question.update(survey_question_params)
      render json: @survey_question
    else
      render json: @survey_question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /survey_questions/1
  def destroy
    @survey_question.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey_question
      @survey_question = SurveyQuestion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def survey_question_params
      params.require(:survey_question).permit(:type, :question, :optional)
    end
end
