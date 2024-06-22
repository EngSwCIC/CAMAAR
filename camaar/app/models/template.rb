class Template < ApplicationRecord
  validates :nome, presence: true

  has_many :formularios
  has_many :questaos
end
