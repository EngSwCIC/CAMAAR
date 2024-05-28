class ClassesController < ApplicationController
  def index
    @department = Department.find(params[:department_inititals])
    @classes = @department.subject_classes
  end
end
