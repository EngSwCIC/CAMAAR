class AvaliacoesController < ApplicationController
  before_action :require_login

  def index
    if current_pessoa.discente
      turmas_ids = current_pessoa.discente.turma_discentes.pluck(:turma_id)
      @formularios_disponiveis = Formulario.where(turma_id: turmas_ids, status: :aberto)
      formularios_respondidos_ids = Resposta.where(discente: current_pessoa.discente)
                                            .joins(:questao)
                                            .pluck('questoes.formulario_id').uniq
      @formularios = @formularios_disponiveis
                       .where.not(id: formularios_respondidos_ids)
                       .includes(turma: [:disciplina, { docente: :pessoa }])
                       .order(created_at: :desc)
    else
      @formularios = []
    end
  end
end