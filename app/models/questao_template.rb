class QuestaoTemplate < ApplicationRecord
  self.table_name = "questoes_template"

  belongs_to :template
  has_many :resposta_itens, class_name: "RespostaItem", foreign_key: :questao_template_id, dependent: :destroy

  def texto
    enunciado
  end

  # Support Hash-like access for view compatibility with pregunta["texto"]
  def [](key)
    if key.to_s == "texto"
      enunciado
    elsif key.to_s == "tipo"
      tipo
    else
      super
    end
  end
end
