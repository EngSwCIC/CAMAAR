# disciplina.rb
class Disciplina < ApplicationRecord
  has_many :turmas, dependent: :destroy

  validates :codigo, presence: true, uniqueness: true
  validates :nome, presence: true
end
