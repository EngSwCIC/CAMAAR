class TurmasController < ApplicationController
  before_action :require_login
  before_action :require_admin

  def index
    @turmas = Turma.where(departamento: current_admin_departamentos)
  end

  def show
    @turma = Turma.where(departamento: current_admin_departamentos).find_by(id: params[:id])
  end
end
