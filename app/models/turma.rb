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
  # Retorna o código da disciplina vinculada à turma.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna uma string com o código da disciplina ou nil.
  #
  # = Efeitos Colaterais:
  # * Nenhum.
  def codigo
    disciplina&.codigo
  end

  # Retorna o código de identificação da turma (nome/apelido).
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna string contendo o código da turma.
  #
  # = Efeitos Colaterais:
  # * Nenhum.
  def nome
    codigo_turma
  end

  # Retorna a quantidade total de matrículas nesta turma.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna integer com a contagem.
  #
  # = Efeitos Colaterais:
  # * Realiza consulta no banco de dados.
  def matriculas_count
    matriculas.count
  end

  # Retorna a quantidade total de respostas associadas aos formulários da turma.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna integer com a contagem de respostas.
  #
  # = Efeitos Colaterais:
  # * Realiza consulta via junção no banco de dados.
  def respostas_count
    formularios.joins(:respostas).count
  end

  # Calcula a média de desempenho das avaliações do tipo "likert" desta turma.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna float representando a média (com uma casa decimal) ou 0.0 caso não haja notas.
  #
  # = Efeitos Colaterais:
  # * Múltiplas consultas complexas ao banco de dados utilizando joins.
  def calcular_media_desempenho
    respostas = Resposta.joins(:formulario).where(formularios: { turma_id: id })
    itens = RespostaItem.where(resposta: respostas).joins(:questao_template).where(questoes_template: { tipo: "likert" })
    valores = itens.pluck(:valor_numerico).compact
    valores.any? ? (valores.sum.to_f / valores.size).round(1) : 0.0
  end
end
