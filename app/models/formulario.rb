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
  validate :mensagem_criacao_personalizada, on: :criacao_por_publico

  private

  def mensagem_criacao_personalizada
    nome = nome_formulario.presence

    if template_formulario.nil? && nome.nil?
      errors.add(:base, "Formulario não pode ser criado, por favor preencha os dados necessários")
      return
    end

    if nome.nil?
      errors.add(:base, "Formulario não pode ser criado, o nome do formulário é obrigatório")
      return
    end

    if template_formulario.nil?
      errors.add(:base, "Formulario #{nome} não pode ser criado, por favor seleciona uma Template")
      return
    end

    if publico_estudante.nil?
      errors.add(:base, "Formulario #{nome} não pode ser criado, por favor selecione o Público-Alvo")
      return
    end

    if turma.nil?
      errors.add(:base, "Formulario #{nome} não pode ser criado, por favor selecione uma Turma")
      return
    end

    if Formulario.where(nome_formulario: nome, turma_id: turma_id, publico_estudante: publico_estudante)
                 .where.not(id: id).exists?
      errors.add(:base, "Formulario #{nome} não pode ser criado, já existe um formulário com este nome para a turma e público-alvo selecionados")
    end
  end

  def turma_possui_matricula_ativa
    return unless publico_estudante?
    return if turma.nil?
    return if turma.matriculas.where(trancado: [ false, nil ]).exists?

    errors.add(:base, "Formulario #{nome_formulario} não pode ser criado, a turma selecionada não possui discentes matriculados")
  end

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
