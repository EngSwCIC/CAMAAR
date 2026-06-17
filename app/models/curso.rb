class Curso < ApplicationRecord
  belongs_to :departamento
  has_many :discentes
  validates :codigo, presence: true, uniqueness: true
  validates :nome, presence: true
end
