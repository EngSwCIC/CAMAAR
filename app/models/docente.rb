# Representa um professor vinculado a uma ou mais turmas.
#
# Herda de +Usuario+ e exige que o atributo +formacao+ esteja preenchido.
# Pode estar associado a múltiplas +Turma+s e é alvo das avaliações
# respondidas pelos discentes via +Formulario+.
class Docente < Usuario
  validates :formacao, presence: true
  has_and_belongs_to_many :turmas, join_table: "docentes_turmas"
end
