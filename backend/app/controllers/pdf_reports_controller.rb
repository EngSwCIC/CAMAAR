class PdfReportsController < ApplicationController

  def index
    @surveys = Survey.all
    @answers = Answer.joins(:member).all
    @questions = Question.all

    render json: { surveys: @surveys, answers: @answers, questions: @questions }

    # render json: PdfReportsSerializer.new(@surveys).serialized_json
  end
end
