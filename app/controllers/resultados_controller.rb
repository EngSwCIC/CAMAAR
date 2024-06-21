class ResultadosController < ApplicationController
  def index
    @forms = FormResponse.all
    render layout: "home"
  end

  def show

  end

  def export
    form = FormResponse.find(params[:id])

    puts "beep"
    send_data form.to_csv, filename: "respostas-camaar-#{Date.today}.csv"
    # puts "hello"

    # redirect_to "/gerenciamento/resultados"
  end
end
