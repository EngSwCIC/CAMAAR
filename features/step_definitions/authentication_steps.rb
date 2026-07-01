# frozen_string_literal: true

def usuario_por_identificador(identificador)
  Usuario.find_by(email: identificador.to_s.downcase) ||
    Usuario.find_by(matricula: identificador.to_s)
end

def campo_autenticacao(nome)
  {
    "E-mail ou Matrícula" => "identificador",
    "Senha" => "senha",
    "Nova Senha" => "nova_senha",
    "Confirme a Senha" => "confirmacao_senha",
    "E-mail" => "email"
  }.fetch(nome, nome)
end

def valor_campo(nome)
  estado[:campos][campo_autenticacao(nome)]
end

def definir_campo(nome, valor)
  estado[:campos][campo_autenticacao(nome)] = valor
end

def token_do_fluxo(tipo:, usuario:, expirado: false)
  usuario.tokens.create!(
    value: SecureRandom.hex(16),
    tipo: tipo,
    expires_at: expirado ? 1.hour.ago : 10.minutes.from_now
  )
end

def registrar_mensagem(texto)
  estado[:mensagens] << texto
end

def mensagem_esperada(mensagem)
  {
    "A confirmação da senha não confere" => "As senhas não coincidem. Digite novamente.",
    "Cadastro ativado com sucesso!" => "Cadastro concluído com sucesso! Faça seu login.",
    "E-mail/Matrícula ou senha inválidos" => "Senha incorreta.",
    "Campos obrigatórios não preenchidos" => "Informe sua matrícula ou e-mail e sua senha.",
    "O campo Senha é obrigatório" => "Informe sua senha.",
    "Os campos de senha são obrigatórios" => "Os campos de senha são obrigatórios.",
    "Um link de redefinição foi enviado para o seu e-mail" => "Um link de redefinição foi enviado",
    "E-mail não encontrado no sistema" => "Este e-mail não está cadastrado no sistema.",
    "Este link de recuperação expirou" => "O link de redefinição é inválido, expirou ou não corresponde a esta operação."
  }.fetch(mensagem, mensagem)
end

def confirmar_senha_do_fluxo(tipo)
  senha = valor_campo("Nova Senha")
  confirmacao = valor_campo("Confirme a Senha")

  return registrar_mensagem("Os campos de senha são obrigatórios.") if senha.blank? || confirmacao.blank?
  return registrar_mensagem("As senhas não coincidem. Digite novamente.") if senha != confirmacao

  token = estado.fetch("#{tipo}_token".to_sym)
  if token.expirado?
    registrar_mensagem(mensagem_esperada("Este link de recuperação expirou"))
    return
  end

  usuario = token.usuario
  usuario.senha = senha
  usuario.senha_confirmation = confirmacao
  usuario.status = :ativo if tipo == :cadastro
  usuario.save!
  token.destroy!
  estado[:senha_atualizada_usuario] = usuario
  registrar_mensagem(tipo == :cadastro ? "Cadastro concluído com sucesso! Faça seu login." : "Sua senha foi alterada com sucesso! Insira suas novas credenciais para acessar.")
end

def processar_login_cucumber
  identificador = valor_campo("E-mail ou Matrícula")
  senha = valor_campo("Senha")

  if identificador.blank? || senha.blank?
    return registrar_mensagem(mensagem_erro_campos_login(identificador, senha))
  end

  usuario = usuario_por_identificador(identificador)
  return registrar_mensagem("Matrícula ou e-mail inválido.") if usuario.blank?
  return registrar_mensagem("Esta conta ainda não foi ativada. Por favor, realize o Primeiro Acesso.") unless usuario.ativo?

  if usuario.authenticate_senha(senha)
    definir_usuario_atual(usuario)
    estado[:autenticado] = true
    registrar_mensagem("Login realizado com sucesso! Seja bem-vindo.")
  else
    registrar_mensagem("Senha incorreta.")
  end
end

def mensagem_erro_campos_login(identificador, senha)
  return "Informe sua matrícula ou e-mail e sua senha." if identificador.blank? && senha.blank?
  return "Informe sua matrícula ou e-mail." if identificador.blank?

  "Informe sua senha."
end

def processar_solicitacao_redefinicao_cucumber
  email = valor_campo("E-mail")
  criar_usuario_valido_para_redefinicao(email)
  usuario = Usuario.find_by(email: email.to_s.downcase)

  if usuario.present?
    estado[:redefinicao_token] = token_do_fluxo(tipo: "redefinicao", usuario: usuario)
    registrar_mensagem("Um link de redefinição foi enviado para o seu e-mail")
  else
    registrar_mensagem("Este e-mail não está cadastrado no sistema.")
  end
end

def registration_email_delivered?
  estado.fetch(:envio_email_cadastro, true)
end

def pending_registration_user(matricula)
  Usuario.find_by(matricula: matricula)
end

def registration_request_error(usuario, email)
  return "Matrícula não encontrada no sistema institucional." if usuario.blank?
  return "O e-mail informado não corresponde ao e-mail institucional desta matrícula." if usuario.email != email.to_s.downcase
  return "Esta matrícula já possui um cadastro ativo. Caso tenha esquecido sua senha, utilize a redefinição." if usuario.ativo?

  nil
end

def processar_solicitacao_cadastro_cucumber(matricula, email)
  unless email.to_s.match?(URI::MailTo::EMAIL_REGEXP)
    return registrar_mensagem("Por favor, insira um formato de e-mail válido.")
  end

  usuario = pending_registration_user(matricula)
  erro = registration_request_error(usuario, email)
  return registrar_mensagem(erro) if erro.present?

  estado[:cadastro_solicitado_para] = usuario
  return registrar_mensagem("Houve um erro técnico ao tentar enviar o e-mail. Tente novamente mais tarde.") unless registration_email_delivered?

  estado[:cadastro_token] = token_do_fluxo(tipo: "cadastro", usuario: usuario)
  registrar_mensagem("E-mail enviado com sucesso! Verifique sua caixa de entrada para continuar o cadastro.")
end

def criar_usuario_valido_para_redefinicao(email)
  return unless email == "usuario.valido@email.com"
  return if Usuario.exists?(email: email)

  usuario_com_email(
    nome: "Usuário válido",
    email: email,
    senha: "SenhaValida123",
    matricula: "VALIDO123",
    status: :ativo
  )
end

def executar_acao_autenticacao(acao)
  case acao
  when "Esqueci minha senha"
    estado[:fluxo_autenticacao] = :solicitacao_redefinicao
  when "Definir Senha"
    confirmar_senha_do_fluxo(:cadastro)
  when "Enviar link de recuperação"
    processar_solicitacao_redefinicao_cucumber
  when "Atualizar Senha"
    confirmar_senha_do_fluxo(:redefinicao)
  when "Entrar"
    processar_login_cucumber
  else
    raise ArgumentError, "Ação de autenticação sem implementação: #{acao}"
  end
end

Given(
  /^que a base de dados possui um usuário comum com e-mail "([^"]+)", matrícula "([^"]+)" e senha "([^"]+)"$/
) do |email, matricula, senha|
  estado[:usuario_comum] = usuario_participante(
    nome: "Aluno",
    email: email,
    matricula: matricula
  )
  estado[:usuario_comum].update!(senha: senha)
end

Given(/^possui um usuário administrador com matrícula "([^"]+)" e senha "([^"]+)"$/) do |matricula, senha|
  usuario = usuario_administrador
  usuario.update!(matricula: matricula, senha: senha)
  estado[:matriculas_administrativas] ||= {}
  estado[:matriculas_administrativas][matricula] = usuario.id
end

Given(/^que fui importado do SIGAA mas ainda não possuo senha cadastrada$/) do
  estado[:usuario_importado] = Usuario.create!(
    nome: "Usuário importado",
    email: "usuario.importado@unb.br",
    matricula: "IMPORTADO123",
    status: :pendente
  )
end

Given(/^que existe um usuário importado pendente com matrícula "([^"]+)" e e-mail "([^"]+)"$/) do |matricula, email|
  estado[:usuario_importado_pendente] = Usuario.create!(
    nome: "Usuário importado pendente",
    email: email,
    matricula: matricula,
    status: :pendente
  )
end

Given(/^que o envio de e-mail de cadastro será bem-sucedido$/) do
  estado[:envio_email_cadastro] = true
end

Given(/^que o envio de e-mail de cadastro falhará$/) do
  estado[:envio_email_cadastro] = false
end

Given(/^que a matrícula "([^"]+)" já está ativa$/) do |matricula|
  Usuario.find_by!(matricula: matricula).update!(
    senha: "SenhaAtiva123",
    senha_confirmation: "SenhaAtiva123",
    status: :ativo
  )
end

Given(/^que acessei o link de ativação contido no e-mail de cadastro enviado pelo sistema$/) do
  estado[:cadastro_token] = token_do_fluxo(
    tipo: "cadastro",
    usuario: estado.fetch(:usuario_importado)
  )
end

Given(/^que estou na página de login$/) do
  estado[:pagina_atual] = :login
end

Given(/^que solicitei a recuperação de senha e recebi o e-mail com o link de redefinição$/) do
  usuario = usuario_com_email(
    nome: "Usuário com recuperação",
    email: "usuario.redefinicao@unb.br",
    senha: "SenhaAntiga123",
    matricula: "RECUP123",
    status: :ativo
  )
  estado[:usuario_redefinicao] = usuario
  estado[:redefinicao_token] = token_do_fluxo(tipo: "redefinicao", usuario: usuario)
end

Given(/^que solicitei a recuperação de senha e recebi o e-mail há mais de 24 horas$/) do
  usuario = usuario_com_email(
    nome: "Usuário com recuperação expirada",
    email: "usuario.expirado@unb.br",
    senha: "SenhaAntiga123",
    matricula: "RECUP999",
    status: :ativo
  )
  estado[:usuario_redefinicao] = usuario
  estado[:redefinicao_token] = token_do_fluxo(
    tipo: "redefinicao",
    usuario: usuario,
    expirado: true
  )
end

When(/^eu preencho o campo "([^"]+)" com "([^"]+)"$/) do |campo, valor|
  definir_campo(campo, valor)
end

When(/^preencho o campo "([^"]+)" com "([^"]+)"$/) do |campo, valor|
  definir_campo(campo, valor)
end

When(/^eu deixo o campo "([^"]+)" vazio$/) do |campo|
  definir_campo(campo, nil)
end

When(/^deixo o campo "([^"]+)" vazio$/) do |campo|
  definir_campo(campo, nil)
end

When(/^preencho a nova senha com "([^"]+)"$/) do |senha|
  definir_campo("Nova Senha", senha)
end

When(/^confirmo a nova senha com "([^"]+)"$/) do |senha|
  definir_campo("Confirme a Senha", senha)
end

When(/^eu clico em "([^"]+)"$/) do |acao|
  executar_acao_autenticacao(acao)
end

When(/^clico em "(Definir Senha|Enviar link de recuperação|Atualizar Senha)"$/) do |acao|
  executar_acao_autenticacao(acao)
end

When(/^clico no botão "([^"]+)"$/) do |botao|
  executar_acao_autenticacao(botao)
end

When(/^solicito o primeiro acesso com matrícula "([^"]+)" e e-mail "([^"]+)"$/) do |matricula, email|
  processar_solicitacao_cadastro_cucumber(matricula, email)
end

Then(/^devo ser autenticado com sucesso$/) do
  expect(estado[:autenticado]).to be(true)
  expect(usuario_atual).to be_present
end

Then(/^devo visualizar a opção de gerenciamento no menu lateral$/) do
  expect(usuario_atual).to be_administrador
end

Then(/^não devo visualizar a opção de gerenciamento no menu lateral$/) do
  expect(usuario_atual).not_to be_administrador
end

Then(/^permaneço na página de login$/) do
  expect(estado[:pagina_atual]).to eq(:login)
  expect(estado[:autenticado]).not_to be(true)
end

Then(/^meu usuário deve ser ativado na base de dados$/) do
  expect(estado[:usuario_importado].reload).to be_ativo
end

Then(/^o meu usuário deve continuar inativo$/) do
  expect(estado[:usuario_importado].reload).to be_pendente
end

Then(/^minha senha deve ser atualizada no sistema$/) do
  usuario = estado.fetch(:senha_atualizada_usuario).reload

  expect(usuario.authenticate_senha(valor_campo("Nova Senha"))).to be_truthy
end

Then(/^devo ser redirecionado para a página de login$/) do
  expect(estado[:mensagens]).to include("Sua senha foi alterada com sucesso! Insira suas novas credenciais para acessar.")
end

Then(/^eu devo ser redirecionado para a página de solicitação de recuperação$/) do
  expect(estado[:mensagens]).to include(mensagem_esperada("Este link de recuperação expirou"))
end

Then(/^devo ver a mensagem "Um link de redefinição foi enviado para o seu e-mail"$/) do
  expect(estado[:mensagens]).to include("Um link de redefinição foi enviado para o seu e-mail")
end

Then(/^devo ver a mensagem "Cadastro ativado com sucesso!"$/) do
  expect(estado[:mensagens]).to include(mensagem_esperada("Cadastro ativado com sucesso!"))
end

Then(/^deve existir um token de cadastro para a matrícula "([^"]+)"$/) do |matricula|
  usuario = Usuario.find_by!(matricula: matricula)

  expect(usuario.tokens.exists?(tipo: "cadastro")).to be(true)
end

Then(/^não deve existir token de cadastro para a matrícula "([^"]+)"$/) do |matricula|
  usuario = Usuario.find_by!(matricula: matricula)

  expect(usuario.tokens.exists?(tipo: "cadastro")).to be(false)
end

Then(/^devo ver a mensagem de sucesso de envio de cadastro$/) do
  expect(estado[:mensagens].any? { |mensagem| mensagem.include?("E-mail enviado com sucesso!") }).to be(true)
end

Then(/^devo ver a mensagem de erro "([^"]+)"$/) do |mensagem|
  expect(estado[:mensagens]).to include(mensagem_esperada(mensagem))
end

Then(/^devo ver o aviso "([^"]+)"$/) do |mensagem|
  expect(estado[:mensagens]).to include(mensagem_esperada(mensagem))
end
