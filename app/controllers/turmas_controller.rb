class TurmasController < ApplicationController
  def index
    if current_user&.departamento.present?
      @turmas = Turma.where(departamento: current_user.departamento)
    else
      @turmas = Turma.all
    end
  end
end
