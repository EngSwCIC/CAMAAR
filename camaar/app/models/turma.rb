class Turma < ApplicationRecord
  has_many :matriculas
  has_many :users, through: :matriculas
  belongs_to :materium
end
