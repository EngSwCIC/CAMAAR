class Template < ApplicationRecord
    belongs_to :user
    has_many :formularios

    has_many :questoes_templates
    has_many :questoes, through: :questoes_templates
end
