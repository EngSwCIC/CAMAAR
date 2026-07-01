# frozen_string_literal: true

class UtilizacaoQuestao < ApplicationRecord
  belongs_to :template,
    class_name: "Template",
    foreign_key: :template_id,
    inverse_of: :utilizacoes_questoes

  belongs_to :questao,
    class_name: "Questao",
    foreign_key: :questao_id,
    inverse_of: :utilizacoes_questoes

  belongs_to :parent,
    class_name: "UtilizacaoQuestao",
    foreign_key: :parent_id,
    inverse_of: :children,
    optional: true

  has_many :children,
    class_name: "UtilizacaoQuestao",
    foreign_key: :parent_id,
    inverse_of: :parent,
    dependent: :destroy

  has_many :opcoes, through: :questao, source: :opcoes

  accepts_nested_attributes_for :questao

  before_validation :herdar_template_do_parent

  validates :template, presence: true

  validates :questao, presence: true

  validates :numero,
    presence: true,
    numericality: { only_integer: true, greater_than: 0 },
    uniqueness: { scope: %i[template_id parent_id] }

  validate :parent_deve_pertencer_ao_mesmo_template
  validate :parent_nao_pode_ser_o_proprio_registro
  validate :nao_pode_formar_ciclo

  scope :raizes, -> { where(parent_id: nil) }
  scope :ordenadas, -> { order(:numero, :id) }

  def raiz?
    parent_id.nil?
  end

  private

  def herdar_template_do_parent
    return if parent.blank?
    return if template_id.present?

    self.template = parent.template
  end

  def parent_deve_pertencer_ao_mesmo_template
    return if parent.blank?
    return if parent.template_id == template_id

    errors.add(:parent, "deve pertencer ao mesmo template")
  end

  def parent_nao_pode_ser_o_proprio_registro
    return if parent.blank?
    return if id.blank?
    return unless parent_id == id

    errors.add(:parent, "não pode ser a própria utilização de questão")
  end

  def nao_pode_formar_ciclo
    ancestral = parent

    while ancestral.present?
      if ancestral.id == id
        errors.add(:parent, "não pode formar ciclo")
        break
      end

      ancestral = ancestral.parent
    end
  end
end
