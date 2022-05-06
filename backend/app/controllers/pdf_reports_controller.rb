class PdfReportsController < ApplicationController
  # controller for generating pdf

  def index
    @data = "\n\n\t\tRelatório\n\n"
    Cclass.all.each do |c|
      s = Survey.includes(:cclass).find_by(cclass: c)
      @data += "\tTurma\n\t\tCódigo: #{c.code}\n\tQuestionário\n\t\tCódigo: #{s.code} Nome: #{s.name}\n\n\n"
    end

    render json: { data: @data }
    end
  end
end
