class ResultadosController < ApplicationController
  def index
    @study_classes = StudyClass.all
    render layout: "home"
  end

  def show

  end

  def export
    study_class = StudyClass.find(params[:id])
    forms = FormResponse.find_with_study_class(study_class)

    if forms.length == 0
      flash[:notice] = "Nenhum formulário respondido."
      redirect_to "/gerenciamento/resultados"
      return
    end

    csv = FormResponse.to_csv(forms)

    send_data csv, filename: "respostas-#{study_class.name}-#{Date.today}.csv"

    flash[:notice] = "Relatório baixado com sucesso."
  end
end
