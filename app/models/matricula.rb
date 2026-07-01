# app/models/matricula.rb
class Matricula < ApplicationRecord
  belongs_to :discente
  belongs_to :turma

  validates :discente_id, uniqueness: {
    scope: :turma_id,
    message: "já está matriculado nesta turma"
  }
end
