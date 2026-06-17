class Turma < ApplicationRecord
  self.table_name = "turmas"

  belongs_to :disciplina
  belongs_to :departamento
  belongs_to :docente, class_name: "Usuario", foreign_key: "docente_id", optional: true
  has_many :matriculas, dependent: :destroy
  has_many :usuarios, through: :matriculas
  has_many :formularios, dependent: :destroy

  validates :codigo_turma, presence: true, uniqueness: { scope: :semestre }
  validates :semestre, presence: true
  def codigo
    disciplina&.codigo
  end

  def nome
    codigo_turma
  end

  def matriculas_count
    matriculas.count
  end

  def respostas_count
    formularios.joins(:respostas).count
  end
end
