# frozen_string_literal: true

# Instância publicada de um template para uma turma e público-alvo.
#
# Cada formulário gera avaliações pendentes para o público selecionado. As
# questões são copiadas do template como snapshot independente — alterações no
# template não afetam formulários já publicados.
#
# Valida unicidade de +turma + template + publico_alvo+ e exige que o
# administrador criador pertença ao mesmo departamento da turma.
class Formulario < ApplicationRecord
  # Público que deve responder ao formulário.
  #
  # Valores:
  # - +docentes+: professores da turma.
  # - +discentes+: alunos da turma.
  #
  # O valor participa da validação de unicidade junto com +turma_id+ e
  # +template_id+ — não é permitido publicar o mesmo template para a mesma
  # turma e público-alvo mais de uma vez.
  enum :publico_alvo, {
    docentes: 0,
    discentes: 1
  }

  belongs_to :adm,
    class_name: "PerfilAdm",
    foreign_key: :adm_id,
    inverse_of: :formularios

  belongs_to :turma,
    class_name: "Turma",
    inverse_of: :formularios

  belongs_to :template,
    class_name: "Template",
    optional: true,
    inverse_of: :formularios

  has_many :questoes,
    class_name: "Questao",
    dependent: :destroy,
    inverse_of: :formulario

  has_many :avaliacoes,
    class_name: "Avaliacao",
    dependent: :restrict_with_error,
    inverse_of: :formulario

  validates :adm, presence: true
  validates :turma, presence: true
  validates :publico_alvo,
    presence: true,
    uniqueness: {
      scope: %i[turma_id template_id],
      message: "já possui formulário para esta turma e template"
    }

  validate :adm_deve_pertencer_ao_departamento_da_turma

  before_validation :definir_criado_em

  # Ordena formulários do mais recente ao mais antigo.
  #
  # Retorno:
  # - Relação ordenada por +criado_em+ e +id+ decrescentes.
  scope :recentes, -> {
    order(criado_em: :desc, id: :desc)
  }

  # Filtra formulários cuja turma pertence ao departamento informado.
  #
  # Argumentos:
  # - +departamento+: departamento usado no filtro.
  #
  # Retorno:
  # - Relação restrita às turmas do departamento.
  scope :do_departamento, ->(departamento) {
    joins(turma: :materia)
      .where(materias: { departamento_id: departamento.id })
  }

  # Filtra formulários de turmas do semestre letivo atual.
  #
  # Retorno:
  # - Relação restrita às turmas retornadas por +Turma.do_semestre_atual+.
  scope :do_semestre_atual, -> {
    joins(:turma).merge(Turma.do_semestre_atual)
  }

  # Filtra formulários criados pelo administrador informado.
  #
  # Argumentos:
  # - +adm+: perfil administrador criador.
  #
  # Retorno:
  # - Relação com +adm_id+ igual ao administrador.
  scope :criados_por, ->(adm) { where(adm_id: adm&.id) }

  # Filtra formulários criados por outros administradores.
  #
  # Argumentos:
  # - +adm+: perfil administrador usado como referência de exclusão.
  #
  # Retorno:
  # - Relação com +adm_id+ diferente do administrador.
  scope :criados_por_outros, ->(adm) { where.not(adm_id: adm&.id) }

  ##
  # Retorna as participações na turma que compõem o público-alvo do formulário.
  #
  # Argumentos:
  # - Não recebe argumentos. Usa +turma+ e +publico_alvo+ do formulário.
  #
  # Retorno:
  # - Participações docentes quando +publico_alvo+ é +docentes+.
  # - Participações discentes quando +publico_alvo+ é +discentes+.
  # - Relação vazia quando o público-alvo não é reconhecido.
  #
  # Efeitos colaterais:
  # - Não altera o banco de dados.
  # - Retorna relações que podem consultar o banco quando materializadas.
  def participacoes_alvo
    return turma.participantes_docentes if docentes?
    return turma.participantes_discentes if discentes?

    ParticipacaoTurma.none
  end

  ##
  # Cria uma avaliação pendente para cada participação do público-alvo.
  #
  # Argumentos:
  # - Não recebe argumentos. Usa as participações retornadas por
  #   +participacoes_alvo+.
  #
  # Retorno:
  # - +nil+ após processar todas as participações.
  #
  # Efeitos colaterais:
  # - Insere registros de +Avaliacao+ via +find_or_create_by!+ para cada
  #   participação retornada por +participacoes_alvo+.
  def criar_avaliacoes_pendentes!
    participacoes_alvo.find_each do |participacao|
      avaliacoes.find_or_create_by!(participacao_turma: participacao)
    end
  end

  ##
  # Verifica se o formulário foi criado pelo administrador informado.
  #
  # Argumentos:
  # - +perfil_adm+: perfil administrador a comparar.
  #
  # Retorno:
  # - +true+ quando +adm_id+ coincide com o id do administrador.
  # - +false+ quando o perfil está ausente ou pertence a outro administrador.
  #
  # Efeitos colaterais:
  # - Não altera o banco de dados nem modifica estado interno.
  def criado_por?(perfil_adm)
    adm_id == perfil_adm&.id
  end

  private

  def definir_criado_em
    self.criado_em ||= Time.current
  end

  def adm_deve_pertencer_ao_departamento_da_turma
    return if adm.blank?
    return if turma.blank?
    return if adm.departamento_id == turma.departamento_id

    errors.add(:adm, "deve pertencer ao mesmo departamento da turma")
  end
end
