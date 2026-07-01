# Representa uma avaliação do sistema, associada a um template e uma turma,
# podendo ser do tipo discente ou docente.

class Avaliacao < ApplicationRecord
  self.table_name = 'avaliacaos'

  TIPOS = %w[discente docente].freeze

  belongs_to :template
  belongs_to :turma
  has_many :respostas, dependent: :destroy

  validates :data_inicio, :data_fim, presence: true
  validates :tipo, inclusion: { in: TIPOS }
  validate :data_fim_posterior_a_data_inicio

  scope :para_discentes, -> { where(tipo: 'discente') }
  scope :respondidas_por, ->(user) { joins(:respostas).where(respostas: { user_id: user.id }).distinct }
  scope :nao_respondidas_por, ->(user) { where.not(id: respondidas_por(user)) }

  # Retorna as avaliações visíveis para +user+.
  #
  # +user+ - instância de +User+.
  # Para admins devolve todas as avaliações. Para discentes devolve apenas
  # as avaliações do tipo "discente" das turmas em que estão matriculados
  # e que ainda não foram respondidas por eles.
  # Retorna um +ActiveRecord::Relation+. Sem efeitos colaterais.
  def self.visiveis_para(user)
    return all if user.admin?

    para_discentes
      .where(turma_id: user.turmas.select(:id))
      .nao_respondidas_por(user)
  end

  # Indica se +user+ já respondeu a esta avaliação.
  #
  # +user+ - instância de +User+.
  # Retorna +true+ ou +false+. Sem efeitos colaterais.
  def respondida_por?(user)
    respostas.exists?(user_id: user.id)
  end

  # Conta quantos usuários distintos já responderam a esta avaliação.
  #
  # Não recebe argumentos.
  # Retorna um inteiro. Sem efeitos colaterais.
  def total_respondentes
    respostas.distinct.count(:user_id)
  end

  # Retorna as questões do template associado a esta avaliação.
  #
  # Não recebe argumentos.
  # Retorna um +ActiveRecord::Relation+ de +Questao+. Sem efeitos colaterais.
  def questoes_com_respostas
    template.questoes
  end

  private

  def data_fim_posterior_a_data_inicio
    if data_inicio.present? && data_fim.present? && data_fim <= data_inicio
      errors.add(:data_fim, "deve ser posterior à data de início")
    end
  end
end