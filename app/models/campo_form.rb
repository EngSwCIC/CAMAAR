# Representa uma opção de resposta instanciada em um +ElementoForm+.
#
# É criado a partir de um +Campo+ de template no momento em que o formulário
# é enviado a uma turma. Quando um usuário seleciona esta opção, um
# +RespostaElem+ é criado referenciando este campo.
class CampoForm < ApplicationRecord
  belongs_to :elemento_form
  has_many :resposta_elems, dependent: :destroy
  validates :ordem, presence: true
end
