class Disciplina < ApplicationRecord
  self.primary_key = 'codigo'
  has_many :turmas, foreign_key: 'disciplina_id', dependent: :destroy
end