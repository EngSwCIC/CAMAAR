class Turma < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments
  has_many :formularios, dependent: :destroy

  validates :code, :name, :class_code, :semester, presence: true
  validates :code, uniqueness: { scope: %i[class_code semester] }

  # Discentes matriculados na turma
  def discentes
    User.joins(:enrollments).where(enrollments: { turma_id: id, role: "discente" })
  end

  # Docente responsável (pode ser nil)
  def docente
    User.joins(:enrollments).where(enrollments: { turma_id: id, role: "docente" }).first
  end

  # Identificação amigável para listagens/seleção
  def nome_completo
    "#{code} - #{name} (#{class_code} - #{semester})"
  end
end
