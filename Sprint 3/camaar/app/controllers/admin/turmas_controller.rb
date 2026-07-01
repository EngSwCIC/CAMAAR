# frozen_string_literal: true

# Lists turmas restricted to the current admin's own department
# (Issue #106 - Gerenciamento por departamento).
class Admin::TurmasController < ApplicationController
  before_action :require_admin!
  layout 'authenticated'

  # Loads @turmas scoped to the signed-in admin's department.
  #
  # Does not receive arguments. Returns no value; sets @turmas
  # for the view. No database writes (read-only).
  def index
    @turmas = Turma.joins(:disciplina)
                   .where(disciplinas: { department: current_user.department })
                   .includes(:disciplina)
                   .order('disciplinas.codigo, turmas.semestre')
  end
end