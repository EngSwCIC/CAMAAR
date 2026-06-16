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

  private

  def data_fim_posterior_a_data_inicio
    if data_inicio.present? && data_fim.present? && data_fim <= data_inicio
      errors.add(:data_fim, "deve ser posterior à data de início")
    end
  end
end