class RespostaPergunta < ApplicationRecord
  belongs_to :pergunta
  belongs_to :pergunta_formulario
end
