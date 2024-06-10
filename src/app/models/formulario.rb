class Formulario < ApplicationRecord
    belongs_to :turma
    belongs_to :template
    has_many :respostas
end
