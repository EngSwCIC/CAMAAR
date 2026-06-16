class Resposta < ApplicationRecord
  self.table_name = "respostas"

  belongs_to :formulario
  belongs_to :user
  belongs_to :question

  # Um usuário responde cada questão de um formulário no máximo uma vez
  validates :user_id, uniqueness: { scope: %i[formulario_id question_id] }
end
