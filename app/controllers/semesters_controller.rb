class SemestersController < ApplicationController
  def index
    @semesters = Semester.all

    respond_to do |format|
      format.html do
        redirect_to manager_path 
      end

      format.csv do 
        send_data @semesters.to_csv, filename: "resultados_semestres.csv"
      end

    end
  end

  def show
    @semester = Semester.find(Semester.current_semester_id)

    respond_to do |format|
      format.html do
        redirect_to manager_path
      end

      format.csv do 
        send_data @semester.to_csv, filename: "resultados_#{@semester.to_s}.csv"
      end

    end
  end

end
