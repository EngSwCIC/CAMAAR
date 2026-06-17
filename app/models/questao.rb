class Questao < ApplicationRecord
  belongs_to :formulario
  has_many :respostas, dependent: :destroy
  serialize :opcoes, coder: JSON
  enum tipo_resposta: { radio: 0, texto: 1 }
end