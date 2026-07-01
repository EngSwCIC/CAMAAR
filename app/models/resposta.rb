# Representa a resposta de um +Discente+ a uma +Questao+ de um formulário.
class Resposta < ApplicationRecord
  belongs_to :questao
  belongs_to :discente
end
