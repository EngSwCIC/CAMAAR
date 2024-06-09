class Formulario < ApplicationRecord
    belongs_to :formulario_template
    has_many :reports_alunos
    has_many:reports_professors
end
