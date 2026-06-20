class PagesController < ApplicationController
  before_action :require_login
  before_action :require_admin, only: :gerenciamento

  def gerenciamento; end

  def avaliacoes
    @formularios_pendentes = formularios_pendentes
  end

  def relatorios; end

  private

  def formularios_pendentes
    formularios_por_perfil
      .where.not(id: current_usuario.resposta_formularios.select(:formulario_id))
      .includes(turma: [ :materia, { professor: :usuario } ])
      .order(:nome_formulario)
  end

  def formularios_por_perfil
    return formularios_pendentes_do_estudante if current_usuario.estudante?
    return formularios_pendentes_do_professor if current_usuario.professor?

    Formulario.none
  end

  def formularios_pendentes_do_estudante
    return Formulario.none unless current_usuario.estudante

    Formulario
      .joins(turma: :matriculas)
      .where(
        publico_estudante: true,
        matriculas: {
          estudante_id: current_usuario.estudante.id,
          trancado: [ false, nil ]
        }
      )
      .distinct
  end

  def formularios_pendentes_do_professor
    return Formulario.none unless current_usuario.professor

    Formulario.where(
      publico_estudante: false,
      turma_id: current_usuario.professor.turma_ids
    )
  end
end
