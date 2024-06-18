class Template < ApplicationRecord
  belongs_to :docente
  belongs_to :formulario
  has_many :questaos, dependent: :destroy
  accepts_nested_attributes_for :questao, reject_if: :all_blank, allow_destroy: true

  validates :nome, presence: true
end
