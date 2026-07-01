# frozen_string_literal: true

class Opcao < ApplicationRecord
  belongs_to :questao,
    class_name: "Questao",
    foreign_key: :questao_id,
    inverse_of: :opcoes

  has_many :opcoes_escolhidas,
    class_name: "OpcaoEscolhida",
    foreign_key: :opcao_id,
    inverse_of: :opcao,
    dependent: :restrict_with_error

  before_validation :normalizar_texto

  validates :questao, presence: true

  validates :numero,
    presence: true,
    numericality: { only_integer: true, greater_than: 0 },
    uniqueness: { scope: :questao_id }

  validates :texto, presence: true, length: { maximum: 2_000 }

  validate :opcao_deve_pertencer_a_questao_objetiva

  scope :ordenadas, -> { order(:numero, :id) }

  private

  def normalizar_texto
    self.texto = texto.to_s.strip if texto.present?
  end

  def opcao_deve_pertencer_a_questao_objetiva
    return if questao.blank?
    return if questao.objetiva?

    errors.add(:questao, "deve ser objetiva para possuir opções")
  end
end
