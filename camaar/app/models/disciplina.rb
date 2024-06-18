# disciplina.rb
class Disciplina < ApplicationRecord
  has_many :classes, dependent: :destroy

  validates :codigo, presence: true, uniqueness: true
  validates :nome, presence: true
end
