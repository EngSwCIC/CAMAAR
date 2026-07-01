# frozen_string_literal: true

require "json"

def registrar_mensagem_sigaa(tipo, mensagem)
  estado[:mensagens] << mensagem
  estado[:ultima_mensagem_sigaa] = { tipo: tipo, texto: mensagem }
end

def departamento_sigaa
  usuario_atual&.perfil_adm&.departamento ||
    Departamento.first ||
    Departamento.create!(nome: "Departamento SIGAA")
end

def pending_invitation_user(matricula, profile)
  usuario = Usuario.create!(
    nome: "#{profile.to_s.humanize} pendente",
    email: "#{matricula.to_s.parameterize}@unb.br",
    matricula: matricula,
    status: :pendente
  )
  estado[:usuario_pendente_convite] = usuario
end

def pending_invitation_class(matricula)
  materia = materia_com_nome(
    "Disciplina de convite #{matricula}",
    departamento_nome: departamento_sigaa.nome,
    codigo: codigo_para("Convite #{matricula}")
  )

  Turma.find_or_create_by!(
    materia: materia,
    ano: Time.zone.today.year,
    semestre: :primeiro,
    numero: 1
  )
end

def create_pending_discente_invitation(matricula)
  usuario = pending_invitation_user(matricula, :discente)
  perfil = PerfilDiscente.find_or_initialize_by(id: usuario.id)
  associar_usuario_ao_perfil(perfil, usuario)
  perfil.save!

  ParticipacaoTurma.create!(
    usuario: usuario,
    turma: pending_invitation_class(matricula),
    tipo_participacao: :discente
  )
end

def create_pending_docente_invitation(matricula)
  usuario = pending_invitation_user(matricula, :docente)
  perfil = PerfilDocente.find_or_initialize_by(id: usuario.id)
  associar_usuario_ao_perfil(perfil, usuario)
  perfil.departamento = departamento_sigaa
  perfil.save!
end

def invitation_result
  estado.fetch(:resultado_envio_convites)
end

def turma_sigaa_padrao
  estado[:sigaa][:turmas].first || {
    nome: "DADOS ATUALIZADOS",
    codigo: "SIGAA000"
  }
end

def turma_sigaa_para_participante(participante)
  return { nome: participante[:turma], codigo: participante[:codigo] } if participante[:codigo].present?

  turma_sigaa_padrao
end

def sigaa_participantes_do_contexto
  participantes = estado[:sigaa][:participantes].dup

  estado[:sigaa][:atualizacoes].each do |matricula, alteracoes|
    usuario = Usuario.find_by!(matricula: matricula)
    participantes << {
      nome: alteracoes.fetch(:nome, usuario.nome),
      matricula: matricula,
      email: alteracoes.fetch(:email, usuario.email),
      turma: turma_sigaa_padrao[:nome],
      codigo: turma_sigaa_padrao[:codigo]
    }
  end

  participantes
end

def sigaa_turmas_do_contexto(participantes)
  turmas = estado[:sigaa][:turmas].dup
  participantes.each { |participante| turmas << turma_sigaa_para_participante(participante) }
  turmas.uniq { |turma| turma[:codigo] }
end

def sigaa_payload
  participantes = sigaa_participantes_do_contexto
  turmas = sigaa_turmas_do_contexto(participantes)

  {
    "materias" => turmas.map do |turma|
      {
        "codigo" => turma[:codigo],
        "nome" => turma[:nome],
        "departamento_id" => departamento_sigaa.id
      }
    end,
    "turmas" => turmas.map do |turma|
      {
        "numero" => 1,
        "ano" => Time.zone.today.year,
        "semestre" => 1,
        "materia_codigo" => turma[:codigo]
      }
    end,
    "usuarios_docentes" => [],
    "usuarios_discentes" => participantes.map do |participante|
      turma = turma_sigaa_para_participante(participante)
      {
        "matricula" => participante[:matricula],
        "nome" => participante[:nome],
        "email" => participante[:email],
        "turmas_matriculadas" => [
          {
            "materia_codigo" => turma[:codigo],
            "numero_turma" => 1,
            "ano" => Time.zone.today.year,
            "semestre" => 1
          }
        ]
      }
    end
  }
end

def caminho_sigaa_cucumber
  Rails.root.join("tmp", "sigaa-cucumber-#{object_id}.json")
end

def capturar_snapshot_sigaa
  estado[:sigaa][:snapshot] = {
    turmas: Turma.order(:id).pluck(:id, :numero, :ano, :semestre, :materia_id),
    usuarios: Usuario.order(:id).pluck(:id, :nome, :email, :matricula, :status),
    turmas_count: Turma.count,
    usuarios_count: Usuario.count,
    tokens_count: Token.count
  }
end

def processar_importacao_sigaa_cucumber
  capturar_snapshot_sigaa

  case estado[:sigaa][:erro]
  when :indisponivel
    registrar_mensagem_sigaa(:erro, "Não foi possível buscar os dados. Tente novamente mais tarde.")
    return
  when :json_invalido
    registrar_mensagem_sigaa(:erro, "Os dados recebidos do SIGAA são inválidos.")
    return
  end

  path = caminho_sigaa_cucumber
  File.write(path, JSON.generate(sigaa_payload))
  resultado = SIGAA::ImportData.call(path: path)

  if resultado.success?
    mensagem = estado[:sigaa][:atualizacoes].present? ? "Dados atualizados com sucesso!" : "Dados importados com sucesso!"
    registrar_mensagem_sigaa(:sucesso, mensagem)
  else
    registrar_mensagem_sigaa(:erro, mensagem_erro_sigaa(resultado))
  end
ensure
  FileUtils.rm_f(path) if defined?(path) && path.present?
end

def mensagem_erro_sigaa(resultado)
  return "Não foi possível solicitar a definição de senha: e-mail do participante não informado." if resultado.errors.any? { |erro| erro.include?("Email") }

  resultado.message
end

Given(/^que o sistema não possui nenhuma turma cadastrada$/) do
  Avaliacao.delete_all
  Formulario.delete_all
  ParticipacaoTurma.delete_all
  Turma.delete_all
end

Given(/^que o sistema não possui nenhum usuário cadastrado$/) do
  Avaliacao.delete_all
  ParticipacaoTurma.delete_all
  PerfilAdm.delete_all
  PerfilDiscente.delete_all
  PerfilDocente.delete_all
  Usuario.delete_all
end

Given(/^que o sistema possui a turma "([^"]+)" \(([^)]+)\) cadastrada$/) do |nome, codigo|
  materia = materia_com_nome(
    nome,
    departamento_nome: "Departamento de Ciência da Computação",
    codigo: codigo
  )

  Turma.find_or_create_by!(
    materia: materia,
    ano: Time.zone.today.year,
    semestre: :primeiro,
    numero: 1
  )
end

Given(/^que o sistema não possui o usuário "([^"]+)" \(([^)]+)\) cadastrado$/) do |_nome, matricula|
  usuario = Usuario.find_by(matricula: matricula)
  usuario&.destroy!
end

Given(/^que o SIGAA contém a turma "([^"]+)" \(([^)]+)\)$/) do |nome, codigo|
  estado[:sigaa][:turmas] << { nome: nome, codigo: codigo }
end

Given(
  /^que o SIGAA contém as turmas "([^"]+)" \(([^)]+)\), "([^"]+)" \(([^)]+)\) e "([^"]+)" \(([^)]+)\)$/
) do |nome1, codigo1, nome2, codigo2, nome3, codigo3|
  estado[:sigaa][:turmas].concat(
    [
      { nome: nome1, codigo: codigo1 },
      { nome: nome2, codigo: codigo2 },
      { nome: nome3, codigo: codigo3 }
    ]
  )
end

Given(/^esta turma contém o participante "([^"]+)" \(([^)]+)\)$/) do |nome, matricula|
  estado[:sigaa][:participantes] << {
    nome: nome,
    matricula: matricula,
    email: "#{matricula}@unb.br"
  }
end

Given(
  /^que o SIGAA contém o participante "([^"]+)" \(([^)]+)\) na turma "([^"]+)" \(([^)]+)\)$/
) do |nome, matricula, turma, codigo|
  estado[:sigaa][:participantes] << {
    nome: nome,
    matricula: matricula,
    turma: turma,
    codigo: codigo,
    email: "#{matricula}@unb.br"
  }
end

Given(
  /^que o SIGAA contém o participante "([^"]+)" \(([^)]+)\) na turma "([^"]+)" \(([^)]+)\) sem e-mail cadastrado$/
) do |nome, matricula, turma, codigo|
  estado[:sigaa][:participantes] << {
    nome: nome,
    matricula: matricula,
    turma: turma,
    codigo: codigo,
    email: nil
  }
end

Given(/^que o SIGAA retorna um arquivo JSON inválido$/) do
  estado[:sigaa][:erro] = :json_invalido
end

Given(/^que o SIGAA está indisponível$/) do
  estado[:sigaa][:erro] = :indisponivel
  capturar_snapshot_sigaa
end

Given(/^que existe um discente pendente de cadastro no meu departamento com matrícula "([^"]+)"$/) do |matricula|
  create_pending_discente_invitation(matricula)
end

Given(/^que existe um docente pendente de cadastro no meu departamento com matrícula "([^"]+)"$/) do |matricula|
  create_pending_docente_invitation(matricula)
end

Given(/^que o envio de convites de cadastro será bem-sucedido$/) do
  allow_any_instance_of(SIGAA::SendPendingInvitations)
    .to receive(:enviar_email_convite_admin)
    .and_return(true)
end

Given(/^que o envio de convites de cadastro falhará$/) do
  allow_any_instance_of(SIGAA::SendPendingInvitations)
    .to receive(:enviar_email_convite_admin)
    .and_return(false)
end

Given(
  /^que o usuário "([^"]+)" \(([^)]+)\) já existe no sistema com o e-mail "([^"]+)"$/
) do |nome, matricula, email|
  usuario_participante(nome: nome, email: email, matricula: matricula)
end

Given(
  /^que o usuário "([^"]+)" \(([^)]+)\) já existe no sistema com o nome "([^"]+)"$/
) do |_nome_original, matricula, nome|
  usuario_participante(
    nome: nome,
    email: "#{matricula}@unb.br",
    matricula: matricula
  )
end

Given(
  /^que o usuário "([^"]+)" \(([^)]+)\) já existe no sistema com o e-mail "([^"]+)" e o nome "([^"]+)"$/
) do |_nome_original, matricula, email, nome|
  usuario_participante(nome: nome, email: email, matricula: matricula)
end

Given(
  /^a fonte de dados externa indica que o e-mail de "([^"]+)" agora é "([^"]+)"$/
) do |matricula, email|
  estado[:sigaa][:atualizacoes][matricula] ||= {}
  estado[:sigaa][:atualizacoes][matricula][:email] = email
end

Given(
  /^a fonte de dados externa indica que o nome de "([^"]+)" agora é "([^"]+)"$/
) do |matricula, nome|
  estado[:sigaa][:atualizacoes][matricula] ||= {}
  estado[:sigaa][:atualizacoes][matricula][:nome] = nome
end

Given(
  /^a fonte de dados externa indica que o e-mail de "([^"]+)" agora é "([^"]+)" e o nome agora é "([^"]+)"$/
) do |matricula, email, nome|
  estado[:sigaa][:atualizacoes][matricula] = { email: email, nome: nome }
end

When(/^eu clico no botão "Importar dados"$/) do
  processar_importacao_sigaa_cucumber
end

When(/^eu clico no botão "Solicitar definição de senha"$/) do
  processar_importacao_sigaa_cucumber
end

When(/^envio as solicitações de cadastro pelo gerenciamento$/) do
  estado[:resultado_envio_convites] = SIGAA::SendPendingInvitations.call(
    current_user: usuario_atual
  )
end

Then(/^a turma "([^"]+)" \(([^)]+)\) deve ser cadastrada no sistema$/) do |nome, codigo|
  expect(Materia.exists?(nome: nome, codigo: codigo)).to be(true)
end

Then(/^o usuário "([^"]+)" \(([^)]+)\) deve ser cadastrado no sistema$/) do |_nome, matricula|
  expect(Usuario.exists?(matricula: matricula)).to be(true)
end

Then(/^o usuário "([^"]+)" deve estar matriculado na turma "([^"]+)"$/) do |nome, turma|
  usuario = Usuario.find_by!(nome: nome)
  materia = Materia.find_by!(nome: turma)

  expect(usuario.turmas.joins(:materia).where(materias: { id: materia.id })).to exist
end

Then(/^as 3 matérias devem ser cadastradas no sistema$/) do
  expect(Materia.count).to eq(3)
end

Then(/^as 3 turmas devem ser cadastradas no sistema$/) do
  expect(Turma.count).to eq(3)
end

Then(/^nenhuma matéria ou turma deve ser duplicada$/) do
  expect(Materia.distinct.count(:codigo)).to eq(Materia.count)
  expect(Turma.distinct.count(:id)).to eq(Turma.count)
end

Then(/^nenhuma nova turma deve ser cadastrada no sistema$/) do
  expect(Turma.count).to eq(estado[:sigaa].dig(:snapshot, :turmas_count))
end

Then(/^nenhum novo usuário deve ser cadastrado no sistema$/) do
  expect(Usuario.count).to eq(estado[:sigaa].dig(:snapshot, :usuarios_count))
end

Then(/^nenhuma turma existente deve ser alterada no sistema$/) do
  expect(Turma.order(:id).pluck(:id, :numero, :ano, :semestre, :materia_id)).to eq(
    estado[:sigaa].dig(:snapshot, :turmas)
  )
end

Then(/^nenhum usuário existente deve ser alterado no sistema$/) do
  expect(Usuario.order(:id).pluck(:id, :nome, :email, :matricula, :status)).to eq(
    estado[:sigaa].dig(:snapshot, :usuarios)
  )
end

Then(/^nenhum usuário duplicado deve ser criado$/) do
  expect(Usuario.distinct.count(:email)).to eq(Usuario.count)
end

Then(/^o e-mail do usuário "([^"]+)" deve ser atualizado para "([^"]+)"$/) do |matricula, email|
  usuario = Usuario.find_by!(matricula: matricula)

  expect(usuario.email).to eq(email)
end

Then(/^o nome do usuário "([^"]+)" deve ser atualizado para "([^"]+)"$/) do |matricula, nome|
  usuario = Usuario.find_by!(matricula: matricula)

  expect(usuario.nome).to eq(nome)
end

Then(/^o usuário "([^"]+)" \(([^)]+)\) deve estar pendente de definição de senha$/) do |_nome, matricula|
  usuario = Usuario.find_by!(matricula: matricula)

  expect(usuario).to be_pendente
end

Then(/^o usuário "([^"]+)" \(([^)]+)\) não deve possuir senha definida$/) do |_nome, matricula|
  usuario = Usuario.find_by!(matricula: matricula)

  expect(usuario.senha_digest).to be_blank
end

Then(/^o usuário "([^"]+)" \(([^)]+)\) não deve ser cadastrado no sistema$/) do |_nome, matricula|
  expect(Usuario.exists?(matricula: matricula)).to be(false)
end

Then(/^nenhuma solicitação de definição de senha deve ser enviada$/) do
  expect(Token.count).to eq(estado[:sigaa].dig(:snapshot, :tokens_count))
end

Then(/^eu devo ver a mensagem de sucesso "([^"]+)"$/) do |mensagem|
  expect(estado[:mensagens]).to include(mensagem)
  expect(estado[:ultima_mensagem_sigaa][:tipo]).to eq(:sucesso)
end

Then(/^eu devo ver a mensagem de erro "([^"]+)"$/) do |mensagem|
  expect(estado[:mensagens]).to include(mensagem)
  expect(estado[:ultima_mensagem_sigaa][:tipo]).to eq(:erro)
end

Then(/^eu devo ver o resultado de envio de convites com 1 sucesso$/) do
  expect(invitation_result).to be_success
  expect(invitation_result.successes).to eq(1)
  expect(invitation_result.errors).to be_empty
end

Then(/^eu devo ver o aviso de que não há usuários pendentes no departamento$/) do
  expect(invitation_result).to be_empty
  expect(invitation_result.successes).to eq(0)
end

Then(/^eu devo ver erro de envio de convites$/) do
  expect(invitation_result.status).to eq(:partial)
  expect(invitation_result.successes).to eq(0)
  expect(invitation_result.errors.join).to include("Falha de comunicação com a Brevo.")
end
