##
# Define a model para representar uma questão de um formulário, incluindo validações e métodos auxiliares para gerenciar opções de múltipla escolha.
# == Schema:
#  * id: integer, primary key
#  * template_id: integer, foreign key para o template
#  * enunciado: string, enunciado da questão
#  * tipo: string, tipo da questão (discursiva ou múltipla escolha)
class Question < ApplicationRecord
  # Define os tipos possíveis de questão, que são "discursiva" e "múltipla escolha".
  TIPOS = %w[discursiva multipla_escolha].freeze

  belongs_to :template, inverse_of: :questions

  validates :enunciado, presence: true
  validates :tipo, inclusion: { in: TIPOS }
  validates :opcoes, presence: true, if: :multipla_escolha?

  def multipla_escolha? #:nodoc:
    tipo == "multipla_escolha"
  end

  def opcoes_lista #:nodoc:
    opcoes.to_s.split("\n").map(&:strip).reject(&:blank?)
  end
end
