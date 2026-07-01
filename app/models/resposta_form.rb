# Representa a submissão completa de um formulário de avaliação por um usuário.
#
# Registra qual +Usuario+ respondeu qual +Formulario+ e em que data. Um usuário
# só pode submeter uma resposta por formulário (unicidade do par usuario_id +
# formulario_id). Agrega os +RespostaElem+s com as respostas individuais a cada questão.
class RespostaForm < ApplicationRecord
  belongs_to :formulario
  belongs_to :usuario
  has_many :resposta_elems, dependent: :destroy
  validates :data_submissao, presence: true
  validates :usuario_id, uniqueness: {
    scope: :formulario_id
  }
end
