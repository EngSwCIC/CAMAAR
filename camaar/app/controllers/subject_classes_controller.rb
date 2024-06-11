class SubjectClassesController < ApplicationController
  layout "admin"

  def index
    @errors = []
    @admin = current_admin

    unless @admin
      @errors << "Admin não encontrado"
      return
    end

    @coordinator = Coordinator.find_by(admin_id: @admin.id)
    unless @coordinator
      @errors << "Coordenador não encontrado"
      return
    end

    @department = Department.find_by(id: @coordinator.department_id)
    unless @department
      @errors << "Departamento não encontrado"
      return
    end

    @subject_classes = SubjectClass.where(department_id: @department.id)

    if @subject_classes.empty?
      @errors << "O departamento não possui turmas"
    end
  end
end
