class Disciplina < ApplicationRecord
  belongs_to :departamento
  has_many :turmas, dependent: :destroy
  validates :codigo, presence: true, uniqueness: true
  validates :nome, presence: true
end
