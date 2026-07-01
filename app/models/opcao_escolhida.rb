# frozen_string_literal: true

class OpcaoEscolhida < ApplicationRecord
  belongs_to :resposta,
    class_name: "Resposta",
    inverse_of: :opcoes_escolhidas

  belongs_to :opcao,
    class_name: "Opcao",
    inverse_of: :opcoes_escolhidas

  validates :resposta, presence: true
  validates :opcao, presence: true

  validates :opcao_id,
    uniqueness: {
      scope: :resposta_id,
      message: "já foi escolhida nesta resposta"
    }

  validate :opcao_deve_pertencer_a_questao_da_resposta
  validate :resposta_deve_ser_de_questao_objetiva

  private

  def opcao_deve_pertencer_a_questao_da_resposta
    return if resposta.blank?
    return if opcao.blank?
    return if resposta.questao_id == opcao.questao_id

    errors.add(:opcao, "deve pertencer à questão respondida")
  end

  def resposta_deve_ser_de_questao_objetiva
    return if resposta.blank?
    return if resposta.questao.blank?
    return if resposta.questao.objetiva?

    errors.add(:resposta, "deve pertencer a uma questão objetiva")
  end
end
