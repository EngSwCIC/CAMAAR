class SubjectClassesController < ApplicationController
  layout "admin"

  def index
    @errors = []
    @admin = current_admin
    @coordinator = Coordinator.find_by(admin_id: @admin.id)
    @department = Department.find(@coordinator.department_id)
    @subject_classes = SubjectClass.where(department_id: @department.id)

    if not @subject_classes
      @errors << "O departamento não possui turmas"
      render :index
    end
  end
end
