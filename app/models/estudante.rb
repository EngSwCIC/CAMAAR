class Estudante < ApplicationRecord
  belongs_to :usuario

  has_many :matriculas
  has_many :turmas, through: :matriculas
end
