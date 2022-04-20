class LikertQuestionsController < ApplicationController
  before_action :set_likert_question, only: %i[ show update destroy ]

  # GET /likert_questions
  def index
    @likert_questions = LikertQuestion.all

    render json: @likert_questions
  end

  # GET /likert_questions/1
  def show
    render json: @likert_question
  end

  # POST /likert_questions
  def create
    @likert_question = LikertQuestion.new(likert_question_params)

    if @likert_question.save
      render json: @likert_question, status: :created, location: @likert_question
    else
      render json: @likert_question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /likert_questions/1
  def update
    if @likert_question.update(likert_question_params)
      render json: @likert_question
    else
      render json: @likert_question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /likert_questions/1
  def destroy
    @likert_question.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_likert_question
      @likert_question = LikertQuestion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def likert_question_params
      params.require(:likert_question).permit(:question)
    end
end
