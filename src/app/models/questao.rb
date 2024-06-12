class Questao < ApplicationRecord
    has_and_belongs_to_many :templates
    has_many :respostas     
end
