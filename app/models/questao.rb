# Representa uma questão de um formulário de avaliação.
# Copiada a partir de +TemplateQuestao+ no momento da criação do formulário.
# O campo +opcoes+ armazena alternativas em JSON (para tipo +:radio+).
class Questao < ApplicationRecord
  belongs_to :formulario
  has_many :respostas, dependent: :destroy
  serialize :opcoes, coder: JSON
  enum tipo_resposta: { radio: 0, texto: 1 }
end
