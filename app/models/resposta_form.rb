class RespostaForm < ApplicationRecord
  belongs_to :formulario
  belongs_to :usuario
  has_many :resposta_elems, dependent: :destroy
  validates :data_submissao, presence: true
  validates :usuario_id, uniqueness: {
    scope: :formulario_id
  }
end
