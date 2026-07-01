# frozen_string_literal: true

# Representa um modelo reutilizável de formulário de avaliação.
#
# Um template pertence a um administrador, possui utilizações de questões e pode
# ser usado como base para criar formulários com cópias independentes das
# questões.
class Template < ApplicationRecord
  belongs_to :adm,
    class_name: "PerfilAdm",
    foreign_key: :adm_id,
    inverse_of: :templates

  has_many :utilizacoes_questoes,
    class_name: "UtilizacaoQuestao",
    foreign_key: :template_id,
    inverse_of: :template,
    dependent: :destroy

  has_many :questoes, through: :utilizacoes_questoes, source: :questao

  has_many :formularios,
    class_name: "Formulario",
    foreign_key: :template_id,
    inverse_of: :template,
    dependent: :nullify

  accepts_nested_attributes_for :utilizacoes_questoes,
    allow_destroy: true,
    reject_if: :utilizacao_questao_em_branco?

  before_validation :normalizar_titulo
  before_validation :preencher_criado_em

  validates :adm, presence: true

  validates :titulo,
    presence: true,
    length: { maximum: 255 },
    uniqueness: { scope: :adm_id, case_sensitive: false }

  validates :descricao, length: { maximum: 2_000 }, allow_blank: true

  validates :criado_em, presence: true

  validate :deve_ter_ao_menos_uma_questao

  scope :recentes, -> { order(criado_em: :desc, id: :desc) }
  scope :criados_por, ->(adm) { where(adm_id: adm&.id) }
  scope :criados_por_outros, ->(adm) { where.not(adm_id: adm&.id) }

  ##
  # Verifica se o template foi criado pelo administrador informado.
  #
  # Argumentos:
  # - +perfil_adm+: perfil administrativo usado na comparação de autoria.
  #
  # Retorno:
  # - Retorna +true+ quando +perfil_adm+ existe e seu id é igual a +adm_id+.
  # - Retorna +false+ quando +perfil_adm+ é nulo ou pertence a outro
  #   administrador.
  #
  # Efeitos colaterais:
  # - Não altera estado em memória nem persiste dados no banco.
  def criado_por?(perfil_adm)
    perfil_adm.present? && adm_id == perfil_adm.id
  end

  ##
  # Retorna as questões do template na ordem configurada.
  #
  # Argumentos:
  # - Não recebe argumentos.
  #
  # Retorno:
  # - Retorna uma relação de +UtilizacaoQuestao+ com +questao+ e +opcoes+
  #   pré-carregadas e ordenadas.
  #
  # Efeitos colaterais:
  # - Pode consultar o banco de dados ao materializar a relação.
  # - Não altera registros.
  def questoes_ordenadas
    utilizacoes_questoes.includes(:questao, :opcoes).ordenadas
  end

  private

  ##
  # Remove espaços extras do título antes da validação.
  #
  # Argumentos:
  # - Não recebe argumentos.
  #
  # Retorno:
  # - Retorna a string normalizada quando há título presente.
  # - Retorna +nil+ quando o título está em branco.
  #
  # Efeitos colaterais:
  # - Altera o atributo +titulo+ do objeto em memória.
  # - Não persiste a alteração no banco por si só.
  def normalizar_titulo
    self.titulo = titulo.to_s.strip if titulo.present?
  end

  ##
  # Preenche a data de criação do template quando ela ainda não existe.
  #
  # Argumentos:
  # - Não recebe argumentos.
  #
  # Retorno:
  # - Retorna o valor final de +criado_em+.
  #
  # Efeitos colaterais:
  # - Pode alterar o atributo +criado_em+ do objeto em memória.
  # - Não persiste a alteração no banco por si só.
  def preencher_criado_em
    self.criado_em ||= Time.current
  end

  ##
  # Valida se o template mantém ao menos uma questão não removida.
  #
  # Argumentos:
  # - Não recebe argumentos.
  #
  # Retorno:
  # - Retorna +nil+ quando há pelo menos uma utilização válida.
  # - Retorna o objeto de erros quando adiciona uma mensagem de validação.
  #
  # Efeitos colaterais:
  # - Pode adicionar erro em +errors[:utilizacoes_questoes]+.
  # - Não altera o banco de dados.
  def deve_ter_ao_menos_uma_questao
    questoes_validas = utilizacoes_questoes.reject(&:marked_for_destruction?)
    return if questoes_validas.any?

    errors.add(:utilizacoes_questoes, "deve conter ao menos uma questão")
  end

  ##
  # Decide se uma utilização de questão aninhada deve ser ignorada.
  #
  # Argumentos:
  # - +attributes+: hash de atributos recebido pelo nested attributes da
  #   utilização de questão.
  #
  # Retorno:
  # - Retorna +true+ quando a utilização é nova e não possui questão,
  #   enunciado ou opções preenchidas.
  # - Retorna +false+ quando há id persistido, questão referenciada ou conteúdo
  #   preenchido.
  #
  # Efeitos colaterais:
  # - Não altera estado em memória nem persiste dados no banco.
  def utilizacao_questao_em_branco?(attributes)
    return false if persisted_or_referenced_questao?(attributes)

    questao_attributes_em_branco?(attributes["questao_attributes"] || {})
  end

  ##
  # Verifica se os atributos apontam para uma utilização ou questão existente.
  #
  # Argumentos:
  # - +attributes+: hash de atributos da utilização de questão.
  #
  # Retorno:
  # - Retorna +true+ quando há +"id"+ ou +"questao_id"+ preenchido.
  # - Retorna +false+ quando ambos estão ausentes ou em branco.
  #
  # Efeitos colaterais:
  # - Não altera estado em memória nem persiste dados no banco.
  def persisted_or_referenced_questao?(attributes)
    attributes.values_at("id", "questao_id").any?(&:present?)
  end

  ##
  # Verifica se os atributos aninhados da questão estão em branco.
  #
  # Argumentos:
  # - +attributes+: hash de atributos da questão aninhada.
  #
  # Retorno:
  # - Retorna +true+ quando o enunciado está em branco e nenhuma opção possui
  #   texto.
  # - Retorna +false+ quando há enunciado ou alguma opção preenchida.
  #
  # Efeitos colaterais:
  # - Não altera estado em memória nem persiste dados no banco.
  def questao_attributes_em_branco?(attributes)
    attributes["enunciado"].blank? &&
      opcoes_attributes_em_branco?(attributes["opcoes_attributes"])
  end

  ##
  # Verifica se todas as opções aninhadas estão em branco.
  #
  # Argumentos:
  # - +attributes+: hash, array ou valor nulo com atributos de opções.
  #
  # Retorno:
  # - Retorna +true+ quando nenhuma opção possui +"texto"+ preenchido.
  # - Retorna +false+ quando ao menos uma opção possui texto.
  #
  # Efeitos colaterais:
  # - Não altera estado em memória nem persiste dados no banco.
  def opcoes_attributes_em_branco?(attributes)
    nested_attributes_values(attributes).none? do |opcao_attributes|
      opcao_attributes["texto"].present?
    end
  end

  ##
  # Normaliza atributos aninhados para uma lista iterável.
  #
  # Argumentos:
  # - +attributes+: coleção de atributos em formato hash, array ou valor nulo.
  #
  # Retorno:
  # - Retorna +[]+ quando +attributes+ está em branco.
  # - Retorna +attributes.values+ quando recebe hash.
  # - Retorna +Array(attributes)+ nos demais casos.
  #
  # Efeitos colaterais:
  # - Não altera estado em memória nem persiste dados no banco.
  def nested_attributes_values(attributes)
    return [] if attributes.blank?
    return attributes.values if attributes.is_a?(Hash)

    Array(attributes)
  end
end
