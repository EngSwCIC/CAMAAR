# Representa um estudante (aluno) cadastrado no sistema.
#
# Herda de +Usuario+ e obrigatoriamente pertence a um +Curso+. Pode estar
# matriculado em múltiplas +Turma+s, nas quais receberá formulários de
# avaliação para responder.
class Discente < Usuario
  validates :curso_id, presence: true
  has_and_belongs_to_many :turmas, join_table: "discentes_turmas"
end
