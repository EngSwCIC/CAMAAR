##
# Representa uma questão pertencente a um template ou a um formulário clonado.
class Questao < ApplicationRecord
  # A chave estrangeira é nula para template se pertencer a formulário, e vice-versa
  belongs_to :template, optional: true
  belongs_to :formulario, optional: true
  has_many :respostas, class_name: "Respostum", dependent: :destroy

  validates :enunciado, presence: true
end
