# frozen_string_literal: true

Given(/^que existe um departamento chamado "([^"]+)"$/) do |nome|
  departamento_com_nome(nome)
end

Given(/^que existe um usuário administrador cadastrado no sistema$/) do
  estado[:usuario_administrador] = usuario_administrador
end

Given(/^que existe um usuário não administrador cadastrado no sistema$/) do
  estado[:usuario_nao_administrador] = usuario_nao_administrador
end

Given(/^que existe um usuário participante cadastrado no sistema$/) do
  estado[:usuario_participante] = usuario_participante
end

Given(/^que estou autenticado como administrador$/) do
  definir_usuario_atual(estado[:usuario_administrador] || usuario_administrador)
end

Given(/^que estou autenticado como administrador do "([^"]+)"$/) do |departamento|
  definir_usuario_atual(usuario_administrador(departamento: departamento))
end

Given(/^que existe um administrador pertencente ao departamento "([^"]+)"$/) do |departamento|
  estado[:administrador_do_contexto] = usuario_administrador(
    departamento: departamento
  )
end

Given(/^que estou autenticado como esse administrador$/) do
  definir_usuario_atual(estado.fetch(:administrador_do_contexto))
end

Given(/^que estou autenticado como participante$/) do
  definir_usuario_atual(estado[:usuario_participante] || usuario_participante)
end

Given(/^que estou autenticado como usuário não administrador$/) do
  definir_usuario_atual(
    estado[:usuario_nao_administrador] || usuario_nao_administrador
  )
end

Given(/^que eu estou logado como Administrador$/) do
  definir_usuario_atual(usuario_administrador)
end

Given(
  /^que existe uma matéria chamada "([^"]+)" pertencente ao departamento "([^"]+)"$/
) do |materia, departamento|
  materia_com_nome(materia, departamento_nome: departamento)
end

Given(
  /^que existe uma turma "([^"]+)" da matéria "([^"]+)" no semestre atual$/
) do |numero, materia|
  turma_da_materia(numero, materia)
end

Given(/^que estou matriculado na turma "([^"]+)"$/) do |turma_nome|
  turma = turma_com_identificador(turma_nome)
  usuario = usuario_atual || usuario_participante
  definir_usuario_atual(usuario)

  ParticipacaoTurma.find_or_create_by!(
    usuario: usuario,
    turma: turma,
    tipo_participacao: :discente
  )
end

Given(/^que não estou matriculado na turma "([^"]+)"$/) do |turma_nome|
  turma = turma_com_identificador(turma_nome)
  usuario = usuario_atual || usuario_participante

  ParticipacaoTurma.where(usuario: usuario, turma: turma).delete_all
end

Given(/^que existe um template chamado "([^"]+)"$/) do |titulo|
  estado[:template_atual] = template_com_titulo(titulo)
end

Given(/^que existe um template chamado "([^"]+)" criado por mim$/) do |titulo|
  estado[:template_atual] = template_com_titulo(titulo, adm: adm_atual)
end

Given(
  /^que o template "([^"]+)" possui a questão "([^"]+)"$/
) do |titulo, enunciado|
  template = Template.find_by!(titulo: titulo)
  next if template.questoes.exists?(enunciado: enunciado)

  questao = Questao.create!(enunciado: enunciado, tipo: :discursiva)
  template.utilizacoes_questoes.create!(
    questao: questao,
    numero: template.utilizacoes_questoes.count + 1
  )
end

Given(/^que não existem templates criados por mim$/) do
  Template.where(adm: adm_atual).destroy_all
end

Given(
  /^que existe um formulário criado a partir do template "([^"]+)"$/
) do |titulo|
  template = Template.find_by!(titulo: titulo)
  turma = turma_com_identificador("Cálculo 1")
  estado[:formulario_anterior] = formulario_para_turma(turma, template: template)
end

Given(
  /^que existe um formulário chamado "([^"]+)" criado a partir do template "([^"]+)"$/
) do |nome, titulo|
  template = Template.find_by!(titulo: titulo)
  turma = turma_com_identificador("Cálculo 1")
  formulario = formulario_para_turma(turma, template: template)

  estado[:formularios_por_nome][nome] = formulario
end

Given(
  /^que existe um formulário chamado "([^"]+)" associado à turma "([^"]+)" da matéria "([^"]+)"$/
) do |nome, turma_numero, materia_nome|
  turma = turma_da_materia(turma_numero, materia_nome)
  adm = usuario_administrador(departamento: turma.departamento.nome).perfil_adm
  formulario = formulario_para_turma(turma, adm: adm)

  estado[:formularios_por_nome][nome] = formulario
end

Given(/^que existe um formulário pendente para a turma "([^"]+)"$/) do |turma_nome|
  turma = turma_com_identificador(turma_nome)
  usuario = usuario_atual || usuario_participante
  definir_usuario_atual(usuario)

  formulario = formulario_para_turma(turma)
  participacao = ParticipacaoTurma.find_by(usuario: usuario, turma: turma)

  if participacao.present?
    Avaliacao.find_or_create_by!(
      formulario: formulario,
      participacao_turma: participacao
    )
  end

  estado[:formulario_atual] = formulario
end

Given(/^que não possuo formulários pendentes nas minhas turmas$/) do
  usuario = usuario_atual || usuario_participante
  Avaliacao.joins(:participacao_turma)
    .where(participacoes_turmas: { usuario_id: usuario.id })
    .destroy_all
end

Then(/^devo ver a turma "([^"]+)" da matéria "([^"]+)"$/) do |numero, materia|
  turma = turma_da_materia(numero, materia)

  expect(Turma.do_departamento(adm_atual.departamento)).to include(turma)
end

Then(/^não devo ver a turma "([^"]+)" da matéria "([^"]+)"$/) do |numero, materia|
  turma = turma_da_materia(numero, materia)

  expect(Turma.do_departamento(adm_atual.departamento)).not_to include(turma)
end

Then(/^devo ver o formulário "([^"]+)"$/) do |nome|
  formulario = estado[:formularios_por_nome].fetch(nome)

  expect(Formulario.do_departamento(adm_atual.departamento)).to include(formulario)
end

Then(/^o formulário "([^"]+)" deve continuar existindo$/) do |nome|
  formulario = estado[:formularios_por_nome].fetch(nome)

  expect(Formulario.exists?(formulario.id)).to be(true)
end

Then(
  /^o formulário deve estar associado à turma "([^"]+)" da matéria "([^"]+)"$/
) do |numero, materia|
  turma = turma_da_materia(numero, materia)

  expect(Formulario.exists?(turma: turma)).to be(true)
end

Then(/^o template "([^"]+)" deve continuar existindo$/) do |titulo|
  expect(Template.exists?(titulo: titulo)).to be(true)
end

Then(/^o template não deve ser criado$/) do
  expect(estado[:template_criado]).to be_nil
end

Then(/^o formulário não deve ser criado$/) do
  expect(estado[:formulario_criado]).to be_nil
end
