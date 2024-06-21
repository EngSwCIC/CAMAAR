class Template < ApplicationRecord
  belongs_to :docente
  has_many :questaos, dependent: :destroy, class_name: "Questao"
  accepts_nested_attributes_for :questaos, reject_if: :all_blank, allow_destroy: true

  validates :nome, presence: true
end
