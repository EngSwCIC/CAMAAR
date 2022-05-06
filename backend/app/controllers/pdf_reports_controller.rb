class PdfReportsController < ApplicationController
  # controller for generating pdf

  def index
<<<<<<< HEAD
    @surveys = params[:class_id] ? Survey.find(params[:class_id]) : Survey.all
    @answers = params[:class_id] ? Answer.joins(:member).find(params[:class_id]) : Answer.joins(:member).all
    @questions = params[:class_id] ? Question.find(params[:class_id]) : Question.all

    render json: { surveys: @surveys, answers: @answers, questions: @questions }, status: :ok

=======
    @data = "\n\n\t\tRelatório\n\n"
    Cclass.all.each do |c|
      s = Survey.includes(:cclass).find_by(cclass: c)
      @data += "\tTurma\n\t\tCódigo: #{c.code}\n\tQuestionário\n\t\tCódigo: #{s.code} Nome: #{s.name}\n\n\n"
    end

    render json: { data: @data }
    end
>>>>>>> 295a2c24abc25a41500fd5d58bba1ef5056a2b22
  end
end
