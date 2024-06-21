class Questao < ApplicationRecord
    has_many :templates, through: :questoes_templates
end
