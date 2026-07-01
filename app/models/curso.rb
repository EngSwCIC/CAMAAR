# Representa um curso de graduação ou pós-graduação.
#
# Pertence a um +Departamento+ e agrega os +Discente+s nele matriculados.
# Identificado de forma única pelo atributo +codigo+.
class Curso < ApplicationRecord
  belongs_to :departamento
  has_many :discentes
  validates :codigo, presence: true, uniqueness: true
  validates :nome, presence: true
end
