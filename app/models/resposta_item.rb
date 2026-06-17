class RespostaItem < ApplicationRecord
  self.table_name = "resposta_itens"

  belongs_to :resposta
  belongs_to :questao_template, class_name: "QuestaoTemplate", foreign_key: "questao_template_id"
end
