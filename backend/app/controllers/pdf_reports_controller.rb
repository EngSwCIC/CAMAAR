class PdfReportsController < ApplicationController
  # controller for generating pdf

  def index
    @surveys = params[:class_id] ? Survey.find(params[:class_id]) : Survey.all
    @answers = params[:class_id] ? Answer.joins(:member).find(params[:class_id]) : Answer.joins(:member).all
    @questions = params[:class_id] ? Question.find(params[:class_id]) : Question.all

    render json: { surveys: @surveys, answers: @answers, questions: @questions }, status: :ok

  end
end
