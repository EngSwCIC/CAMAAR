# :nocov:
# Modelo planejado para armazenar respostas individuais por pergunta.
# A tabela `resposta_perguntas` ainda não foi criada (feature não implementada nesta sprint).
class RespostaPergunta < ApplicationRecord
  belongs_to :pergunta
  belongs_to :pergunta_formulario
end
# :nocov:
