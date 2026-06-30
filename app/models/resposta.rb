##
# Define a model para representar uma resposta de um usuário a uma questão de um formulário, incluindo validações para garantir que cada usuário responda cada questão no máximo uma vez.
# == Schema:
#  * id: integer, primary key
#  * formulario_id: integer, foreign key para o formulário
#  * user_id: integer, foreign key para o usuário
#  * question_id: integer, foreign key para a questão
class Resposta < ApplicationRecord
  self.table_name = "respostas"

  belongs_to :formulario
  belongs_to :user
  belongs_to :question

  # Um usuário responde cada questão de um formulário no máximo uma vez
  validates :user_id, uniqueness: { scope: %i[formulario_id question_id] }
end
