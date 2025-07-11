class Respostum < ApplicationRecord
  belongs_to :formulario
  belongs_to :pergunta
  belongs_to :opcao
  belongs_to :turma
end
