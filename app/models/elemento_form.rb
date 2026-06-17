class ElementoForm < ApplicationRecord
  belongs_to :formulario
  has_many :campo_forms, dependent: :destroy
  validates :ordem, presence: true
end
