class Resposta < ApplicationRecord
  belongs_to :resultado
  belongs_to :questao

  validates :conteudo, presence: true
end
