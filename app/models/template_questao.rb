# Representa uma questão modelo pertencente a um +Template+.
# O campo +opcoes+ armazena alternativas em JSON (usado para questões de
# tipo +:radio+). O campo +tipo_resposta+ pode ser +:radio+ ou +:texto+.
class TemplateQuestao < ApplicationRecord
  belongs_to :template
  serialize :opcoes, coder: JSON
  enum tipo_resposta: { radio: 0, texto: 1 }
end
