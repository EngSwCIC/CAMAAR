# Resposta de um discente a um formulário enviado para sua turma
class FormResponse < ApplicationRecord
  belongs_to :form
  belongs_to :user
  belongs_to :turma

  serialize :answers, coder: JSON

  validates :form, :user, :turma, presence: true
end
