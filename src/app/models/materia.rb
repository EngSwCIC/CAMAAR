##
# Define a associação entre o modelo Materia e o modelo Turma.
#
# == Associações
# - Uma Materia pode ter muitas Turmas associadas a ela.
#
# +effect_side+ Define a associação de dados entre Materia e Turmas.
class Materia < ApplicationRecord
    has_many :turmas
end
