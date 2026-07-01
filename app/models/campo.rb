# Representa uma opção de resposta ou configuração de tipo dentro de um +Elemento+.
#
# Cada campo pertence a um +Elemento+ de template e define o +tipo_elemento+
# ("Texto", "Múltipla Escolha", etc.) e o enunciado da opção. A ordem é única
# dentro do escopo do elemento pai.
class Campo < ApplicationRecord
  belongs_to :elemento
  validates :ordem, presence: true
  validates :ordem, uniqueness: { scope: :elemento_id }
  validates :tipo_elemento, presence: true
end
