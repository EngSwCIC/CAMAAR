class Resposta < ApplicationRecord
  belongs_to :formulario
  belongs_to :pergunta
end
