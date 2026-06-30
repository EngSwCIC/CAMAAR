class Disciplina < ApplicationRecord
  self.table_name = "disciplinas"

  has_many :turmas, dependent: :destroy

  validates :codigo, presence: true, uniqueness: true
  validates :nome, presence: true

  # Retorna o departamento associado à disciplina, baseado na primeira turma, ou o primeiro departamento cadastrado.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna um objeto da classe Departamento ou nil.
  #
  # = Efeitos Colaterais:
  # * Realiza consultas no banco de dados.
  def departamento
    turmas.first&.departamento || Departamento.first
  end
end
