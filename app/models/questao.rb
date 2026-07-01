# frozen_string_literal: true

class Questao < ApplicationRecord
  enum :tipo, {
    objetiva: 0,
    discursiva: 1
  }

  belongs_to :formulario,
    class_name: "Formulario",
    optional: true,
    inverse_of: :questoes

  has_many :utilizacoes_questoes,
    class_name: "UtilizacaoQuestao",
    foreign_key: :questao_id,
    inverse_of: :questao,
    dependent: :restrict_with_error

  has_many :templates, through: :utilizacoes_questoes, source: :template

  has_many :opcoes,
    class_name: "Opcao",
    foreign_key: :questao_id,
    inverse_of: :questao,
    dependent: :destroy

  has_many :respostas,
    class_name: "Resposta",
    foreign_key: :questao_id,
    inverse_of: :questao,
    dependent: :restrict_with_error

  accepts_nested_attributes_for :opcoes,
    allow_destroy: true,
    reject_if: :all_blank

  before_validation :normalizar_enunciado

  validates :enunciado, presence: true, length: { maximum: 4_000 }

  validates :tipo, presence: true, inclusion: { in: tipos.keys }

  validate :questao_objetiva_deve_ter_opcoes_suficientes
  validate :questao_discursiva_nao_deve_ter_opcoes

  scope :objetivas, -> { where(tipo: tipos[:objetiva]) }
  scope :discursivas, -> { where(tipo: tipos[:discursiva]) }

  private

  def normalizar_enunciado
    self.enunciado = enunciado.to_s.strip if enunciado.present?
  end

  def opcoes_validas
    opcoes.reject(&:marked_for_destruction?)
  end

  def questao_objetiva_deve_ter_opcoes_suficientes
    return unless objetiva?
    return if opcoes_validas.size >= 2

    errors.add(:opcoes, "devem ter pelo menos duas alternativas para questão objetiva")
  end

  def questao_discursiva_nao_deve_ter_opcoes
    return unless discursiva?
    return if opcoes_validas.empty?

    errors.add(:opcoes, "não devem existir em questão discursiva")
  end
end
