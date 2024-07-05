##
# Define as associações entre o modelo UserTurma e os modelos User e Turma.
#
# == Associações
# - Um UserTurma pertence a um User.
# - Um UserTurma pertence a uma Turma.
#
# +effect_side+ Estabelece a relação entre um User e uma Turma através da tabela de junção UserTurma. 
class UserTurma < ApplicationRecord
  belongs_to :user
  belongs_to :turma
end
