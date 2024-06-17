class Template < ApplicationRecord
    belongs_to :user
    has_and_belongs_to_many :questoes
    has_many :formularios, foreign_key: 'id_template'
end
