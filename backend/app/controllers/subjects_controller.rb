class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
    render json: @subjects, status: :ok
  end

  def show
    @subject = Subject.find(params[:id])
    render json: @subject, status: :ok
  end

  def admin_report 
    subjects = Subject.all

    subjects = subjects.map { |s| { name: s.code, classes: s.cclasses } }
    subjects = subjects.map do |s|
      {
        name: s[:name],
        classes: s[:classes].map do |c|
          {
            grade: get_class_mean(c),
            name: c.code
          }
        end
      }
    end
    
    render json: subjects
  end

  private
  def get_class_mean(oi)
    a = oi.enrollment.map { |b| b.grade }
    return a.inject(0) { |sum, x| sum + x } / a.size unless a.size == 0
  end
end
