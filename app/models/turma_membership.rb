# Associação entre Turma e User (discentes/docentes cadastrados via User)
class TurmaMembership < ApplicationRecord
  belongs_to :turma
  belongs_to :user
end
