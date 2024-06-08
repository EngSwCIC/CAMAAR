class Materium < ApplicationRecord
    validates :nome, presence: true, uniqueness: true
    validates :codigo, presence: true, uniqueness: true
    validates :horario, presence: true
    validates :semestre, presence: true

    has_many :aluno
    belongs_to :aluno
    belongs_to :departamento
    has_many :professor
    belongs_to :professor
end
