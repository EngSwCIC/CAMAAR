class Turma < ApplicationRecord
  belongs_to :materium
  has_one :formulario
  has_many :matriculas
  has_many :users, through: :matriculas
end
