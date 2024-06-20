class Materia < ApplicationRecord
  validates :nome, presence: true
  validates :codigo, presence: true, format: { with: /\A[A-Z]{3}[0-9]{4}\z/ }

  has_many :turmas
end
