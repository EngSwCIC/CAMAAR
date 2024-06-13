class Formulario < ApplicationRecord
    belongs_to :template
    belongs_to :turma
    has_many :respostas
end
