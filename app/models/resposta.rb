class Resposta < ApplicationRecord
  belongs_to :questao
  belongs_to :discente
end