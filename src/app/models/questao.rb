class Questao < ApplicationRecord
    has_many_and_belongs_to_many :templates
    has_many :respostas     
end
