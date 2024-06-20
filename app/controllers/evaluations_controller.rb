class EvaluationsController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern
  def index
    if self.user_authenticated
      user_info = cookies.signed[:user_info]
      _, _, email = user_info.split('_')
      
      @disciplines_info = Discipline.all_disciplines_with_eval_info(email, admin_user?)
      render 'index'
    else
      redirect_to root_path, alert: "Acesso não autorizado"
    end
  end

  def disciplines
    if self.user_authenticated
      user_info = cookies.signed[:user_info]
      _, _, email = user_info.split('_')

      @disciplines_info = Discipline.all_disciplines_info(email, admin_user?)
      render 'disciplines'
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
