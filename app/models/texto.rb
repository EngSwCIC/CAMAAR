# frozen_string_literal: true

class Texto < ApplicationRecord
  belongs_to :resposta,
    class_name: "Resposta",
    inverse_of: :texto

  validates :resposta, presence: true
  validates :texto, presence: true

  validate :resposta_deve_ser_de_questao_discursiva

  before_validation :normalizar_texto

  private

  def normalizar_texto
    self.texto = texto.to_s.strip
  end

  def resposta_deve_ser_de_questao_discursiva
    return if resposta.blank?
    return if resposta.questao.blank?
    return if resposta.questao.discursiva?

    errors.add(:resposta, "deve pertencer a uma questão discursiva")
  end
end
