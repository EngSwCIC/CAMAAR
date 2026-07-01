# Template de formulário, contendo questões reutilizáveis
class Template < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :parent_template, class_name: "Template", optional: true

  has_many :versions, class_name: "Template", foreign_key: "parent_template_id"
  has_many :questions, dependent: :destroy
  has_many :forms, dependent: :destroy

  before_destroy :ensure_not_in_use_by_forms

  validates :nome, presence: true

  def ensure_not_in_use_by_forms
    return true unless Form.exists?(template_id: id)

    errors.add(:base, "Template está em uso por formulários")
    throw(:abort)
  end

  # Permite usar :name como alias de :nome para compatibilidade com specs
  alias_attribute :name, :nome
end