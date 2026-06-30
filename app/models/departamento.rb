class Departamento < ApplicationRecord
  self.table_name = "departamentos"

  has_many :usuarios, dependent: :destroy
  has_many :turmas, dependent: :destroy

  validates :nome, presence: true, uniqueness: true

  # Retorna ou calcula o código abreviado do departamento.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna uma string com a sigla do departamento (ex: "CIC" ou iniciais).
  #
  # = Efeitos Colaterais:
  # * Nenhum.
  def codigo
    return "CIC" if nome.to_s.upcase.include?("COMPUTAÇÃO")
    nome.to_s.split.map { |word| word[0] }.join.upcase[0..4] rescue "DEP"
  end
end
