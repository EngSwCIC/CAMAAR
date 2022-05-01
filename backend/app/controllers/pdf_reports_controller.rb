class PdfReportsController < ApplicationController

  def index
    if params[:class_id]
      @surveys = Survey.find(params[:class_id])
      @answers = Answer.joins(:member).find(params[:class_id])
      @questions = Question.find(params[:class_id])
    else
      @surveys = Survey.all
      @answers = Answer.joins(:member).all
      @questions = Question.all
    end

    render json: { surveys: @surveys, answers: @answers, questions: @questions }, status: :ok

    # render json: PdfReportsSerializer.new(@surveys).serialized_json
  end
end
