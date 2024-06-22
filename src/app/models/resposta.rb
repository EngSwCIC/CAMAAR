class Resposta < ApplicationRecord
    belongs_to :user
    belongs_to :questao
    belongs_to :formulario
end
