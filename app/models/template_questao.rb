class TemplateQuestao < ApplicationRecord
  belongs_to :template
  serialize :opcoes, coder: JSON 
  enum tipo_resposta: { radio: 0, texto: 1 }
end