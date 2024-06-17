class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @formularios = Formulario.joins(turma: [:professor, :materia], template: [])
      .select('formularios.*, turmas.classCode as turma_classCode, turmas.semestre as turma_semestre, users.nome as professor_name, materias.nome as materia_nome')
  end
end
