class Disciplina < ApplicationRecord
  has_many :turmas, dependent: :destroy
end
