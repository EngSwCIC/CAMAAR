##
# Armazena o valor atribuído a uma questão dentro de uma submissão.
class Respostum < ApplicationRecord
  belongs_to :submissao
  belongs_to :questao
end
