##
# Define as associações entre o modelo Turma e os modelos User, Materia, Formulario e UserTurma.
#
# == Associações
# - Uma Turma pertence a um User (professor) e a uma Materia.
# - Uma Turma pode ter muitos Formularios.
# - Uma Turma pode ter muitos Templates através dos Formularios.
# - Uma Turma pode ter muitos Users através da tabela de junção UsersTurmas.
#
# +effect_side+ Configura as relações de dados entre Turma e os modelos User, Materia, Formulario e UserTurma. 
class Turma < ApplicationRecord
    belongs_to :professor, class_name: 'User', foreign_key: 'id_professor'
    belongs_to :materia
    has_many :formularios
    has_many :templates, through: :formularios
    has_many :users_turmas
    has_many :users, through: :users_turmas
end
