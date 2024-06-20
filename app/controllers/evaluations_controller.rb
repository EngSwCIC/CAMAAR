class EvaluationsController < ApplicationController
  include AuthenticationConcern
  def index
    if self.user_authenticated
      @disciplines_info = Discipline.all_disciplines_info
      render 'index'
    else
      redirect_to root_path, alert: "Acesso não autorizado"
    end
  end

  def show
    @discipline = Discipline.find(params[:id])

    respond_to do |format|
      format.html do 
        redirect_to evaluations_path
      end

      format.csv do
        send_data @discipline.to_csv, filename: "#{@discipline.name}.csv"
      end

    end
  end
end
