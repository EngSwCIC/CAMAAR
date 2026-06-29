# app/models/questao.rb
class Questao < ApplicationRecord
  belongs_to :formulario
  belongs_to :questao_template

  has_many :respostas, dependent: :destroy

  enum :tipo, { aberta: 0, multipla: 1 }

  validates :enunciado, presence: true

  delegate :opcao_questoes, to: :questao_template
end
