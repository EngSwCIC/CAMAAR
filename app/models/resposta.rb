class Resposta < ApplicationRecord
  self.table_name = "respostas"

  belongs_to :formulario
  belongs_to :usuario
  has_many :resposta_itens, class_name: "RespostaItem", dependent: :destroy
end
