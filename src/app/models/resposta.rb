class Resposta < ApplicationRecord
    belongs_to :formulario
    belongs_to :questao
    belongs_to :user
end
