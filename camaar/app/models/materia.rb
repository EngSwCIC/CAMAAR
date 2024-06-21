class Materia < ApplicationRecord
  :nome # , presence: true
  validates :codigo, format: { with: /\A[A-Z]{3}[0-9]{4}\z/ }

  has_many :turmas
end
