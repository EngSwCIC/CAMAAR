class Avaliacao < ApplicationRecord
  belongs_to :participacao_turma,
    class_name: "ParticipacaoTurma",
    inverse_of: :avaliacoes

  belongs_to :formulario,
    class_name: "Formulario",
    inverse_of: :avaliacoes

  has_many :respostas,
    class_name: "Resposta",
    dependent: :destroy,
    inverse_of: :avaliacao

  validates :participacao_turma, presence: true
  validates :formulario, presence: true

  validates :participacao_turma_id,
    uniqueness: {
      scope: :formulario_id,
      message: "já possui avaliação para este formulário"
    }

  validate :participacao_deve_ser_da_turma_do_formulario
  validate :participacao_deve_corresponder_ao_publico_alvo

  scope :respondidas, -> {
    where.not(respondido_em: nil)
  }

  scope :pendentes, -> {
    where(respondido_em: nil)
  }

  ##
  # Verifica se a avaliação já foi preenchida baseando-se na presença de uma data de resposta.
  #
  # Argumentos:
  # - Nenhum.
  #
  # Retorno:
  # - Retorna um booleano (+true+ se a data +respondido_em+ estiver presente, +false+ caso contrário).
  #
  # Efeitos colaterais:
  # - Nenhum efeito colateral no banco de dados. Apenas verificação em memória.
  def respondida?
    respondido_em.present?
  end

  ##
  # Verifica se a avaliação ainda aguarda o preenchimento por parte do usuário.
  #
  # Argumentos:
  # - Nenhum.
  #
  # Retorno:
  # - Retorna um booleano (+true+ se ainda não foi respondida, +false+ caso contrário).
  #
  # Efeitos colaterais:
  # - Nenhum.
  def pendente?
    !respondida?
  end

  ##
  # Carimba a avaliação com a data e hora exatas do momento da submissão, efetivando sua conclusão.
  #
  # Argumentos:
  # - Nenhum.
  #
  # Retorno:
  # - Retorna +true+ se a atualização for salva com sucesso. Levanta uma exceção em caso de falha devido ao uso do +update!+.
  #
  # Efeitos colaterais:
  # - *Banco de Dados (Escrita)*: Executa um comando UPDATE na tabela de avaliações alterando o campo +respondido_em+.
  def marcar_como_respondida!
    update!(respondido_em: Time.current)
  end

  private

  ##
  # Validação customizada. Garante que a participação vinculada a esta avaliação pertence à mesma turma
  # para a qual o formulário foi designado.
  #
  # Argumentos:
  # - Nenhum. Lê os atributos da própria instância (+participacao_turma+ e +formulario+).
  #
  # Retorno:
  # - Retorna +nil+ caso a validação passe ou caso faltem dados.
  #
  # Efeitos colaterais:
  # - Modifica o estado do objeto adicionando uma mensagem de erro ao array interno de +errors+ caso a regra seja violada, impedindo a persistência no banco.
  def participacao_deve_ser_da_turma_do_formulario
    return if participacao_turma.blank?
    return if formulario.blank?
    return if participacao_turma.turma_id == formulario.turma_id

    errors.add(:participacao_turma, "deve pertencer à turma do formulário")
  end

  ##
  # Validação customizada. Assegura que o tipo do participante (ex: discente, docente) corresponde
  # ao público-alvo exigido pelo formulário.
  #
  # Argumentos:
  # - Nenhum.
  #
  # Retorno:
  # - Retorna +nil+ caso a validação passe ou se os dados em memória estiverem incompletos.
  #
  # Efeitos colaterais:
  # - Adiciona uma mensagem de erro ao array interno de +errors+ caso a regra seja violada, impedindo a gravação do registro.
  def participacao_deve_corresponder_ao_publico_alvo
    return if participacao_turma.blank?
    return if formulario.blank?
    return if participacao_turma.corresponde_ao_publico?(formulario.publico_alvo)

    errors.add(:participacao_turma, "não corresponde ao público-alvo do formulário")
  end
end
