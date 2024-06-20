class QuestionsController < ApplicationController
  protect_from_forgery with: :null_session

  def Home
    @questions = Question.all
  end

  def create
    question = Question.new(question_params)
    if question.save
      render json: { status: 'success', question: question }, status: :created
    else
      render json: { status: 'error', errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :question_type, options_attributes: [:text])
  end
end
