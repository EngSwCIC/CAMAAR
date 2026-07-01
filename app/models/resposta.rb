# frozen_string_literal: true

class Resposta < ApplicationRecord
  belongs_to :questao,
    class_name: "Questao",
    inverse_of: :respostas

  belongs_to :avaliacao,
    class_name: "Avaliacao",
    inverse_of: :respostas

  has_one :texto,
    class_name: "Texto",
    dependent: :destroy,
    inverse_of: :resposta

  has_many :opcoes_escolhidas,
    class_name: "OpcaoEscolhida",
    dependent: :destroy,
    inverse_of: :resposta

  has_many :opcoes,
    through: :opcoes_escolhidas

  accepts_nested_attributes_for :texto,
    allow_destroy: true

  accepts_nested_attributes_for :opcoes_escolhidas,
    allow_destroy: true

  validates :questao, presence: true
  validates :avaliacao, presence: true

  validates :questao_id,
    uniqueness: {
      scope: :avaliacao_id,
      message: "já foi respondida nesta avaliação"
    }

  validate :questao_deve_pertencer_ao_formulario
  validate :conteudo_deve_ser_compativel_com_tipo_da_questao

  private

  def questao_deve_pertencer_ao_formulario
    return if questao.blank?
    return if avaliacao.blank?
    return if formulario.blank?
    return if formulario.questoes.exists?(id: questao_id)

    errors.add(:questao, "não pertence ao formulário")
  end

  def conteudo_deve_ser_compativel_com_tipo_da_questao
    return if questao.blank?

    validar_resposta_objetiva if questao.objetiva?
    validar_resposta_discursiva if questao.discursiva?
  end

  def validar_resposta_objetiva
    errors.add(:opcoes_escolhidas, "devem ser informadas") unless possui_opcoes_escolhidas?
    errors.add(:texto, "não deve ser informado em questão objetiva") if possui_texto?
  end

  def validar_resposta_discursiva
    errors.add(:texto, "deve ser informado") unless possui_texto?

    if possui_opcoes_escolhidas?
      errors.add(
        :opcoes_escolhidas,
        "não devem ser informadas em questão discursiva"
      )
    end
  end

  def possui_texto?
    texto&.texto.to_s.strip.present?
  end

  def possui_opcoes_escolhidas?
    opcoes_escolhidas.reject(&:marked_for_destruction?).any?
  end

  def formulario
    avaliacao.formulario
  end
end
