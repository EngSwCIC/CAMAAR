# Exibe os formulários de avaliação disponíveis para o discente autenticado.
class AvaliacoesController < ApplicationController
  before_action :require_login

  # Lista os formulários abertos e ainda não respondidos pelo discente.
  #
  # Efeito colateral: atribui +@formularios+ com os formulários disponíveis
  # ou array vazio se o usuário não for discente.
  def index
    @formularios = current_pessoa.discente ? formularios_para_discente(current_pessoa.discente) : []
  end

  private

  # Busca formulários abertos vinculados às turmas do discente e que ele
  # ainda não respondeu.
  #
  # Parâmetros: +discente+ — instância de +Discente+.
  # Retorno: ActiveRecord::Relation de +Formulario+ ordenados por criação
  # descendente, com turma, disciplina e docente pré-carregados.
  def formularios_para_discente(discente)
    turmas_ids = discente.turma_discentes.pluck(:turma_id)
    disponiveis = Formulario.where(turma_id: turmas_ids, status: :aberto)

    disponiveis
      .where.not(id: formularios_respondidos_ids(discente))
      .includes(turma: [:disciplina, { docente: :pessoa }])
      .order(created_at: :desc)
  end

  # Retorna os IDs dos formulários que o discente já respondeu.
  #
  # Parâmetros: +discente+ — instância de +Discente+.
  # Retorno: Array de IDs (Integer) de formulários já respondidos.
  def formularios_respondidos_ids(discente)
    Resposta.where(discente: discente).joins(:questao).pluck('questoes.formulario_id').uniq
  end
end
