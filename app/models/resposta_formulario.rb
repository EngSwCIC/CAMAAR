class RespostaFormulario < ApplicationRecord
  belongs_to :formulario
  belongs_to :usuario

  has_many :resposta_perguntas
end
