class Usuario < ApplicationRecord
    attribute :isAdmin, :boolean, default: false
    attribute :isAluno, :boolean, default: false
    attribute :isProf, :boolean, default: false
    attribute :curso, :string
    attribute :departamento, :string
end
