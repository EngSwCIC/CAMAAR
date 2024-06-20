class ProfessorsController < ApplicationController
  before_action :authenticate_professor!

  def dashboard
    if current_professor.isadmin?
      @templates = FormularioTemplate.all
      redirect_to edit_template_path(@templates.first)  # Redireciona para a edição do primeiro template
    else
      @formularios = current_professor.formularios
      redirect_to reports_professors_path  # Redireciona para os relatórios dos professores
    end
  end
end
