class SemestersController < ApplicationController
  def index
    @semesters = Semester.all

    respond_to do |format|
      format.html do
        redirect_to manager_path 
      end

      format.csv do 
        send_data @semesters.to_csv, filename: "semesters_results.csv"
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
        send_data @semester.to_csv, filename: "#{@semester.to_s}_results.csv"
      end

    end
  end

end
