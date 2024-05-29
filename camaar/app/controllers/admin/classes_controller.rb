module Admin
  class ClassesController < ApplicationController
    def index
      @department = Department.find_by(initials: params[:department_initials])
      @classes = SubjectClass.where(@department)
    end

    def import
    end
  end
end
