##
# Define a model Turma, representando uma turma de curso, com suas associações, validações e métodos auxiliares.
# == Schema:
#  * id: integer, primary key
#  * code: string, código do curso
#  * name: string, nome do curso
#  * class_code: string, código da turma
#  * semester: string, semestre da turma
#  * departamento: string, departamento responsável pela turma
class Turma < ApplicationRecord
  # Os step definitions (BDD) usam o nome em inglês "department"; o banco usa
  # "departamento". O alias mantém ambos funcionando em queries e setters.
  alias_attribute :department, :departamento

  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments
  has_many :formularios, dependent: :destroy

  validates :code, :name, :class_code, :semester, presence: true
  validates :code, uniqueness: { scope: %i[class_code semester] }

  ##
  # a. Descrição: Filtra as turmas pelo departamento informado; sem departamento, retorna todas.
  # b. Argumentos: Recebe 'department' (String ou nil).
  # c. Retorno: Retorna um ActiveRecord::Relation de turmas.
  # d. Efeitos colaterais: Nenhum.
  def self.do_departamento(department)
    department.present? ? where(department: department) : all
  end

  ##
  # a. Descrição: Cria/recupera a turma a partir de uma linha de CSV do SIGAA (chaveada por código/turma/semestre).
  # b. Argumentos: Recebe 'row' (Hash) com as colunas do CSV.
  # c. Retorno: Retorna a Turma encontrada ou criada, ou nil quando não há código.
  # d. Efeitos colaterais: Insere uma Turma no banco caso ainda não exista.
  def self.upsert_from_row(row)
    code = row["turma_code"]
    return nil if code.blank?

    find_or_create_by!(
      code: code,
      class_code: row["class_code"].presence || "TA",
      semester: row["semester"].presence || "2026.1"
    ) do |t|
      t.name = row["turma_name"].presence || code
      t.department = row["departamento"]
    end
  end

  # Define os discentes matriculados na turma.
  def discentes
    User.joins(:enrollments).where(enrollments: { turma_id: id, role: "discente" })
  end

  # Define os docentes responsáveis pela turma. Retorna apenas o primeiro docente encontrado, caso haja mais de um.
  def docente
    User.joins(:enrollments).where(enrollments: { turma_id: id, role: "docente" }).first
  end

  # Identificação amigável para listagens/seleção
  def nome_completo
    "#{code} - #{name} (#{class_code} - #{semester})"
  end
end
