# Representa uma questão dentro de um +Template+ de avaliação.
#
# Contém um enunciado e uma ordem de exibição, além de possuir múltiplos
# +Campo+s que definem as opções de resposta (para questões de múltipla
# escolha) ou configuram o tipo da questão.
class Elemento < ApplicationRecord
  belongs_to :template
  has_many :campos, dependent: :destroy
  accepts_nested_attributes_for :campos, allow_destroy: true
end
