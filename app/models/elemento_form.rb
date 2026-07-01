# Representa uma questão instanciada em um +Formulario+ de avaliação.
#
# É criado a partir de um +Elemento+ de template no momento em que o formulário
# é enviado a uma turma. Contém o enunciado e o tipo da questão, e agrupa os
# +CampoForm+s com as opções de resposta disponíveis.
class ElementoForm < ApplicationRecord
  belongs_to :formulario
  has_many :campo_forms, dependent: :destroy
  validates :ordem, presence: true
end
