# app/models/disciplina.rb
class Disciplina < ApplicationRecord
  has_many :turmas, dependent: :restrict_with_error

  validates :codigo, presence: true, uniqueness: true
  validates :nome,   presence: true
end
