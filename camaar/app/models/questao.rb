class Questao < ApplicationRecord
  belongs_to :formulario
  belongs_to :template
  has_one :resposta
end
