# frozen_string_literal: true

module TestBuilders
  def create_admin_usuario(**attrs)
    departamento = attrs[:departamento] || Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}")
    defaults = {
      nome: "Administrador",
      email: "#{SecureRandom.hex(4)}@example.com",
      matricula: "ADM#{SecureRandom.hex(5)}",
      status: :ativo,
      senha: "senha12345"
    }
    usuario = Usuario.create!(defaults.merge(attrs.except(:departamento)))
    PerfilAdm.create!(usuario: usuario, departamento: departamento)
    usuario
  end

  def create_usuario(**attrs)
    defaults = {
      nome: "Usuário",
      email: "#{SecureRandom.hex(4)}@example.com",
      matricula: "USR#{SecureRandom.hex(5)}",
      status: :ativo,
      senha: "senha12345"
    }
    Usuario.create!(defaults.merge(attrs))
  end

  def create_template_with_questoes(titulo:, adm: nil, questoes: nil)
    adm ||= create_admin_usuario.perfil_adm
    template = Template.new(titulo: titulo, descricao: "Descrição de teste", adm: adm, criado_em: Time.current)

    (questoes || default_questoes).each_with_index do |questao_attrs, index|
      questao = create_questao_for_template(questao_attrs)
      template.utilizacoes_questoes.build(
        questao: questao,
        numero: numero_utilizacao_template(questao_attrs, index)
      )
    end

    template.save!
    template.utilizacoes_questoes.each(&:save!)
    template
  end

  def create_turma(nome_materia:, numero:, semestre: Turma.semestre_atual, departamento: nil, ano: Date.current.year)
    departamento ||= Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}")
    materia = Materia.create!(
      nome: nome_materia,
      codigo: "#{nome_materia.parameterize}-#{SecureRandom.hex(2)}".upcase,
      departamento: departamento
    )

    Turma.create!(
      materia: materia,
      numero: numero,
      semestre: semestre,
      ano: ano
    )
  end

  def questoes_ordenadas_do_template(template)
    template.utilizacoes_questoes.raizes.ordenadas.includes(:questao).map(&:questao)
  end

  def create_perfil_docente(usuario, departamento: nil, **attrs)
    departamento ||= Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}")
    PerfilDocente.create!(id: usuario.id, usuario: usuario, departamento: departamento, **attrs)
    usuario
  end

  def create_perfil_discente(usuario, matricula: nil, **attrs)
    matricula ||= "2026#{SecureRandom.hex(4)}"
    usuario.update!(matricula: matricula) if usuario.matricula != matricula
    PerfilDiscente.create!(id: usuario.id, usuario: usuario, **attrs)
    usuario
  end

  def create_participacao(usuario:, turma:, tipo_participacao:)
    case tipo_participacao.to_sym
    when :docente
      create_perfil_docente(usuario, departamento: turma.departamento) unless usuario.docente?
    when :discente
      create_perfil_discente(usuario) unless usuario.discente?
    end

    ParticipacaoTurma.create!(usuario: usuario, turma: turma, tipo_participacao: tipo_participacao)
  end

  def create_formulario(turma:, adm: nil, template: nil, publico_alvo: :docentes, criar_avaliacoes: false, **attrs)
    adm ||= create_admin_usuario(departamento: turma.departamento).perfil_adm
    template ||= create_template_with_questoes(titulo: "Formulário de teste", adm: adm)

    formulario = Formulario.create!(
      adm: adm,
      turma: turma,
      template: template,
      publico_alvo: publico_alvo,
      **attrs
    )

    copy_template_snapshot_for(formulario, template)
    formulario.criar_avaliacoes_pendentes! if criar_avaliacoes
    formulario
  end

  private

  def default_questoes
    [
      {
        enunciado: "Como você avalia a disciplina?",
        tipo: :discursiva
      },
      {
        enunciado: "Nota geral",
        tipo: :objetiva,
        opcoes: %w[Ruim Regular Boa Excelente]
      }
    ]
  end

  def create_questao_for_template(questao_attrs)
    attrs = questao_attrs.except(:opcoes, :numero, :posicao, :obrigatoria)
    Questao.new(attrs).tap do |questao|
      build_opcoes_for_template(questao, questao_attrs[:opcoes])
      questao.save!
    end
  end

  def build_opcoes_for_template(questao, opcoes)
    Array(opcoes).each_with_index do |texto, index|
      questao.opcoes.build(numero: index + 1, texto: texto)
    end
  end

  def numero_utilizacao_template(questao_attrs, index)
    questao_attrs[:numero] || questao_attrs[:posicao] || (index + 1)
  end

  def copy_template_snapshot_for(formulario, template)
    return if template.blank?
    return if formulario.questoes.exists?

    Formularios::TemplateQuestionSnapshot.copy(template: template, formulario: formulario)
  end
end

RSpec.configure do |config|
  config.include TestBuilders
end
