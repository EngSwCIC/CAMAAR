class Docente < ApplicationRecord
  belongs_to :pessoa, foreign_key: 'pessoa_id', primary_key: 'usuario'
  has_many :turmas, dependent: :destroy
end