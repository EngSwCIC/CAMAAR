class Resposta < ApplicationRecord
  belongs_to :user
  belongs_to :avaliacao
  belongs_to :questao

  validates :texto, presence: true
  validates :questao_id, uniqueness: { scope: [:user_id, :avaliacao_id] }
end
