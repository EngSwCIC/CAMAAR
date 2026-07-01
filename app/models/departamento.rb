# Representa um departamento acadêmico da instituição.
#
# Agrupa +Curso+s, +Disciplina+s e +Administrador+es. Não pode ser excluído
# enquanto houver cursos ou disciplinas vinculados (+restrict_with_error+).
# Identificado de forma única pelo atributo +codigo+.
class Departamento < ApplicationRecord
  has_many :cursos, dependent: :restrict_with_error
  has_many :disciplinas, dependent: :restrict_with_error
  has_many :administradores
  validates :codigo, presence: true, uniqueness: true
  validates :nome, presence: true
end
