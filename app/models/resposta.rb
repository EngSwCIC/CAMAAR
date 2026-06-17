class Resposta < ApplicationRecord
  belongs_to :formulario
  belongs_to :user
  belongs_to :pergunta

  validates :conteudo, presence: true, if: -> { pergunta&.obrigatoria? }
end
