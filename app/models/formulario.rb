class Formulario < ApplicationRecord
  belongs_to :template_formulario, optional: true
  belongs_to :turma
  belongs_to :criador_formulario

  has_many :resposta_formularios
  has_many :pergunta_formularios
  has_many :perguntas, through: :pergunta_formularios

  after_create :vincular_perguntas_do_template

  validates :nome_formulario,
            presence: { message: "é obrigatório" },
            uniqueness: {
              scope: [ :turma_id, :publico_estudante ],
              message: "já existe para a turma e público-alvo selecionados"
            },
            on: :criacao_por_publico
  validates :template_formulario, presence: { message: "é obrigatório" }, on: :criacao_por_publico
  validates :turma, presence: { message: "é obrigatória" }, on: :criacao_por_publico
  validates :publico_estudante,
            inclusion: {
              in: [ true, false ],
              message: "deve ser Discente ou Docente"
            },
            on: :criacao_por_publico
  validate :turma_possui_matricula_ativa, on: :criacao_por_publico
  validate :validar_ausencia_total, on: :criacao_por_publico
  validate :validar_campos_obrigatorios, on: :criacao_por_publico
  validate :formularios_duplicados, on: :criacao_por_publico

  private

  # Serve como validação para o caso em que o formulário de criação
  # de formulário está totalmente vazio (sem template e sem nome).
  #
  # Argumentos:
  # Não recebe argumentos.
  #
  # Retorna:
  # Nil.
  #
  # Efeitos colaterais:
  # Adiciona um erro em :base quando template e nome estão ambos ausentes.
  def validar_ausencia_total
    return unless template_formulario.nil? && nome_formulario.presence.nil?

    errors.add(:base, "Formulario não pode ser criado, por favor preencha os dados necessários")
  end

  # Serve como validação para as variáveis básicas para criação de um formulário
  # (Nome do Formulário, Template para Criação, Público Alvo e Turma).
  #
  # Argumentos:
  # Não recebe argumentos.
  #
  # Retorna:
  # Nil.
  #
  # Efeitos colaterais:
  # Adiciona um erro em :base com a mensagem do primeiro campo obrigatório
  # ausente (nome, template, público-alvo ou turma, nessa ordem), se houver
  # algum. O nome só é interpolado na mensagem quando ele próprio já está
  # presente.
  def validar_campos_obrigatorios
    nome = nome_formulario.presence

    if nome.nil?
      errors.add(:base, "Formulario não pode ser criado, o nome do formulário é obrigatório")
      return
    end

    atributos_obrigatorios = [
      [ template_formulario.nil?, "por favor seleciona uma Template" ],
      [ publico_estudante.nil?, "por favor selecione o Público-Alvo" ],
      [ turma.nil?, "por favor selecione uma Turma" ]
    ]

    falhou, motivo_falha = atributos_obrigatorios.find { |condicao, _| condicao == true }

    errors.add(:base, "Formulario #{nome} não pode ser criado, #{motivo_falha}") if falhou
  end

  # Serve como validação para o caso de existir um formulário aberto de mesmo nome
  # para o mesmo publico alvo e na mesma turma do formulario que se está criando.
  #
  # Argumentos:
  # Não recebe argumentos.
  #
  # Retorna:
  # Nil.
  #
  # Efeitos colaterais:
  # Consulta o banco por outro formulário com o mesmo nome, turma e
  # público-alvo; adiciona um erro em :base quando encontrado.
  def formularios_duplicados
    nome = nome_formulario.presence

    duplicado = Formulario.where(nome_formulario: nome, turma_id: turma_id, publico_estudante: publico_estudante)
                           .where.not(id: id).exists?
    return unless duplicado

    errors.add(:base, "Formulario #{nome} não pode ser criado, já existe um formulário com este nome para a turma e público-alvo selecionados")
  end

  # Serve como validação para o caso de não haver matrículas em uma turma
  # selecionada durante a criação de um formulário.
  #
  # Argumentos:
  # Não recebe argumentos.
  #
  # Retorna:
  # Nil.
  #
  # Efeitos colaterais:
  # Adiciona um erro em :base quando o formulário é destinado a discentes e
  # a turma selecionada não possui nenhuma matrícula ativa.
  def turma_possui_matricula_ativa
    return unless publico_estudante?
    return if turma.nil?
    return if turma.matriculas.where(trancado: [ false, nil ]).exists?

    errors.add(:base, "Formulario #{nome_formulario} não pode ser criado, a turma selecionada não possui discentes matriculados")
  end

  # Cria uma instância de PerguntaFormulario para cada Pergunta do template
  # vinculado, em um padrão Snapshot (cópia congelada dos dados no momento
  # da criação do formulário).
  #
  # Argumentos:
  # Não recebe argumentos.
  #
  # Retorna:
  # Nil.
  #
  # Efeitos colaterais:
  # Cria um registro PerguntaFormulario no banco para cada Pergunta do
  # template (callback after_create); não faz nada se não houver template
  # ou perguntas.
  def vincular_perguntas_do_template
    template_formulario&.perguntas&.each do |pergunta|
      pergunta_formularios.create!(
        pergunta_id: pergunta.id,
        tipo_pergunta: pergunta.tipo_pergunta,
        enunciado: pergunta.enunciado,
        numero_opcoes: pergunta.numero_opcoes,
        opcoes_radio: pergunta.opcoes_radio,
        gabarito_radio: pergunta.gabarito_radio,
        gabarito_discursiva: pergunta.gabarito_discursiva
      )
    end
  end
end
