# frozen_string_literal: true

require "digest"
require "rspec/expectations"

World(RSpec::Matchers)

module CucumberUsuarioAtual
  class << self
    attr_accessor :usuario
  end
end

module CamaarWorld
  TURMAS_PADRAO = {
    "Cálculo 1" => [ "Cálculo 1", "MAT0001", "A" ],
    "Estrutura de Dados" => [ "Estrutura de Dados", "CIC0090", "C" ],
    "Engenharia de Software" => [ "Engenharia de Software", "CIC0105", "A" ],
    "Métodos de Desenvolvimento de Software - Turma A" => [
      "Métodos de Desenvolvimento de Software",
      "CIC0100",
      "A"
    ],
    "Interação Humano Computador - Turma B" => [
      "Interação Humano Computador",
      "CIC0101",
      "B"
    ],
    "Estrutura de Dados - Turma C" => [ "Estrutura de Dados", "CIC0090", "C" ]
  }.freeze

  def estado
    @estado ||= {
      campos: {},
      mensagens: [],
      formularios_por_nome: {},
      sigaa: { turmas: [], participantes: [], atualizacoes: {} }
    }
  end

  def usuario_atual
    @usuario_atual
  end

  def definir_usuario_atual(usuario)
    @usuario_atual = usuario
    CucumberUsuarioAtual.usuario = usuario
  end

  def administrador_atual
    usuario_atual&.perfil_adm
  end

  def adm_atual
    administrador_atual
  end

  def departamento_com_nome(nome)
    Departamento.find_or_create_by!(nome: nome)
  end

  def matricula_de_teste_para(email)
    "USR#{Digest::SHA256.hexdigest(email.to_s).first(12)}"
  end

  def usuario_com_email(
    nome:,
    email:,
    senha: nil,
    status: :ativo,
    matricula: nil
  )
    usuario = Usuario.find_or_initialize_by(email: email)
    usuario.nome = nome
    if usuario.has_attribute?(:matricula)
      usuario.matricula = matricula.presence ||
        usuario.matricula.presence ||
        matricula_de_teste_para(email)
    end
    usuario.status = status
    usuario.senha = senha if senha.present?
    usuario.save!
    usuario
  end

  def associar_usuario_ao_perfil(perfil, usuario)
    perfil.usuario = usuario
    perfil.usuario_id = usuario.id if perfil.has_attribute?(:usuario_id)
  end

  def usuario_administrador(departamento: "Departamento de Ciência da Computação")
    departamento = departamento_com_nome(departamento)
    usuario = usuario_com_email(
      nome: "Administrador #{departamento.nome}",
      email: "administrador-#{departamento.id}@unb.br",
      senha: "Admin123"
    )

    perfil = PerfilAdm.find_or_initialize_by(id: usuario.id)
    associar_usuario_ao_perfil(perfil, usuario)
    perfil.departamento = departamento
    perfil.save!

    usuario.reload
  end

  def usuario_participante(nome: "Participante", email: "participante@unb.br", matricula: "190084006")
    usuario = usuario_com_email(
      nome: nome,
      email: email,
      senha: "Senha123",
      matricula: matricula
    )
    perfil = PerfilDiscente.find_or_initialize_by(id: usuario.id)
    associar_usuario_ao_perfil(perfil, usuario)
    perfil.save!

    usuario.reload
  end

  def usuario_docente(nome: "Docente", email: "docente@unb.br", departamento: nil)
    departamento ||= departamento_com_nome("Departamento de Ciência da Computação")
    usuario = usuario_com_email(nome: nome, email: email, senha: "Senha123")
    perfil = PerfilDocente.find_or_initialize_by(id: usuario.id)
    associar_usuario_ao_perfil(perfil, usuario)
    perfil.departamento = departamento
    perfil.save!

    usuario.reload
  end

  def usuario_nao_administrador
    usuario_participante(
      nome: "Usuário não administrador",
      email: "nao-administrador@unb.br",
      matricula: "232000000"
    )
  end

  def codigo_para(nome)
    nome
      .parameterize(separator: "_")
      .upcase
      .[](0, 20)
      .presence || "MAT#{Materia.count + 1}"
  end

  def materia_com_nome(nome, departamento_nome:, codigo: nil)
    departamento = departamento_com_nome(departamento_nome)
    materia = Materia.find_or_initialize_by(codigo: codigo || codigo_para(nome))
    materia.nome = nome
    materia.departamento = departamento
    materia.save!
    materia
  end

  def turma_numero(valor)
    return valor.to_i if valor.to_s.match?(/\A\d+\z/)

    valor.to_s.upcase.ord - "A".ord + 1
  end

  def turma_com_identificador(
    identificador,
    departamento_nome: "Departamento de Ciência da Computação"
  )
    materia_nome, codigo, numero = TURMAS_PADRAO.fetch(identificador) do
      [ identificador, codigo_para(identificador), "A" ]
    end

    materia = materia_com_nome(
      materia_nome,
      departamento_nome: departamento_nome,
      codigo: codigo
    )

    Turma.find_or_create_by!(
      materia: materia,
      ano: Time.zone.today.year,
      semestre: :primeiro,
      numero: turma_numero(numero)
    )
  end

  def turma_da_materia(numero, materia_nome)
    materia = Materia.find_by!(nome: materia_nome)

    Turma.find_or_create_by!(
      materia: materia,
      ano: Time.zone.today.year,
      semestre: :primeiro,
      numero: turma_numero(numero)
    )
  end

  def questao_attributes(enunciado:, tipo:, opcoes: [])
    attributes = {
      enunciado: enunciado,
      tipo: tipo
    }

    if opcoes.any?
      attributes[:opcoes_attributes] = opcoes.each_with_index.map do |texto, index|
        { numero: index + 1, texto: texto }
      end
    end

    attributes
  end

  def template_com_titulo(titulo, adm: nil, descricao: nil)
    adm ||= administrador_atual || usuario_administrador.perfil_adm

    Template.find_by(titulo: titulo, adm: adm) || Template.create!(
      titulo: titulo,
      descricao: descricao,
      adm: adm,
      utilizacoes_questoes_attributes: [
        {
          numero: 1,
          questao_attributes: questao_attributes(
            enunciado: "Questão padrão do template #{titulo}",
            tipo: :discursiva
          )
        }
      ]
    )
  end

  def formulario_para_turma(turma, template: nil, adm: nil)
    adm ||= administrador_atual || usuario_administrador(
      departamento: turma.departamento.nome
    ).perfil_adm
    template ||= template_com_titulo("Template padrão", adm: adm)

    Formulario.create!(
      adm: adm,
      turma: turma,
      template: template,
      publico_alvo: :discentes
    ).tap do |formulario|
      copiar_questoes_do_template_para_formulario(formulario, template)
    end
  end

  def copiar_questoes_do_template_para_formulario(formulario, template)
    return formulario if template.blank? || formulario.questoes.exists?

    Formularios::TemplateQuestionSnapshot.copy(template: template, formulario: formulario)
    formulario.reload
  end
end

World(CamaarWorld)

Before do
  CucumberUsuarioAtual.usuario = nil
end

module CucumberApplicationAuthentication
  private

  def current_user
    CucumberUsuarioAtual.usuario || super
  end
end

ApplicationController.prepend(CucumberApplicationAuthentication)
