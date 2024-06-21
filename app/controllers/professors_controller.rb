class ProfessorsController < ApplicationController
  before_action :authenticate_professor!

  def dashboard
    if current_professor.isadmin?
      @templates = FormularioTemplate.all
      redirect_to edit_template_path(@templates.first)  
    else
      @formularios = current_professor.formularios
      redirect_to reports_alunos_path
    end
  end
end
