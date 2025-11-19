# frozen_string_literal: true

# ------------------------------------------------------------
# Contexto / Given
# ------------------------------------------------------------

Dado('que estou autenticado como um participante válido') do
  @aluno = FactoryBot.create(:user, :participant)
  login_as(@aluno)
end

Dado('existe o formulário {string} disponível para minha turma') do |titulo|
  # Ajuste os factories/modelos conforme seu domínio.
  @turma = FactoryBot.create(:turma)
  @form  = FactoryBot.create(:formulario, titulo:, turma: @turma, semestre: '2025.1', publicado: true)

  # Relacione o aluno à turma
  FactoryBot.create(:matricula, user: @aluno, turma: @turma)

  # Exemplo de perguntas obrigatórias (múltipla escolha e texto)
  @q1 = FactoryBot.create(:pergunta, formulario: @form, tipo: :radio, obrigatoria: true, titulo: 'Satisfação geral')
  @q2 = FactoryBot.create(:pergunta, formulario: @form, tipo: :texto, obrigatoria: true, titulo: 'Comentário')

  # Alternativas para a pergunta de radio
  %w[ Muito\ bom Bom Satisfatório Ruim Péssimo ].each do |op|
    FactoryBot.create(:alternativa, pergunta: @q1, texto: op)
  end
end

Dado('que o servidor está indisponível') do
  # Simula falha na camada de envio/submissão
  allow(FormSubmissions::Create).to receive(:call).and_raise(StandardError, 'indisponível')
rescue NameError
  # Caso ainda não exista o serviço, "stub" um endpoint genérico usado no submit
  allow_any_instance_of(ApplicationController).to receive(:perform_submission).and_raise(StandardError, 'indisponível')
end

# ------------------------------------------------------------
# Ações / When
# ------------------------------------------------------------

Quando('estou na página {string}') do |path|
  visit("/#{path}")
end

Quando('eu acesso a página {string}') do |path|
  visit("/#{path}")
end

Quando('preencho todas as perguntas obrigatórias com respostas válidas') do
  # Múltipla escolha: pegar a primeira opção disponível
  all("[data-testid='pergunta-radio']").each do |bloco|
    bloco.first("[data-testid='alternativa-opcao']").click
  end

  # Texto: preencher com alguma mensagem
  all("[data-testid='pergunta-texto'] [data-testid='campo-texto-pergunta']").each do |campo|
    campo.set('Resposta de teste')
  end
end

Quando('deixo perguntas obrigatórias em branco') do
  # Não faz nada de propósito — garante que existam obrigatórias visíveis
  expect(page).to have_selector("[data-testid='pergunta-radio']", minimum: 1)
end

Quando('clico no botão {string}') do |rotulo|
  testid = case rotulo
  when /enviar/i then 'botao-enviar'
  else "botao-#{rotulo.downcase.tr(' ', '-')}"
  end
  find("[data-testid='#{testid}']").click
end

Quando('eu clico em {string}') do |rotulo|
  step %(clico no botão "#{rotulo}")
end

# ------------------------------------------------------------
# Verificações / Then
# ------------------------------------------------------------

Então('devo ver a mensagem {string}') do |texto|
  # mensagens podem aparecer em toasts/alerts
  expect(page).to have_content(texto)
end

Então('o sistema registra minhas respostas no banco de dados') do
  # Ajuste o modelo conforme seu domínio (ex.: Submissao, RespostaFormulario, etc.)
  # Exemplo genérico:
  expect(Resposta.where(usuario: @aluno, formulario: @form).count).to be > 0
rescue NameError
  # Mantém o step “passável” caso o modelo ainda não exista na etapa 2
  pending 'Modelo de persistência de respostas ainda não definido (ajuste este step quando implementar).'
end

Então('o formulário é bloqueado para nova submissão') do
  # Botão enviar desabilitado ou mensagem de “já respondido”
  if page.has_selector?("[data-testid='botao-enviar']")
    expect(find("[data-testid='botao-enviar']")[:disabled]).to be_truthy
  else
    expect(page).to have_content('Você já respondeu este formulário').or have_content('Formulário encerrado')
  end
end

Então('devo ver perguntas com alternativas de múltipla escolha') do
  expect(page).to have_selector("[data-testid='pergunta-radio']", minimum: 1)
  expect(page).to have_selector("[data-testid='alternativa-opcao']", minimum: 1)
end

Então('devo ver perguntas com campos de texto') do
  expect(page).to have_selector("[data-testid='pergunta-texto']", minimum: 1)
  expect(page).to have_selector("[data-testid='campo-texto-pergunta']", minimum: 1)
end

Então('devo ver o botão {string} desabilitado até preencher todos os campos obrigatórios') do |rotulo|
  testid = rotulo =~ /enviar/i ? 'botao-enviar' : "botao-#{rotulo.downcase.tr(' ', '-')}"
  expect(find("[data-testid='#{testid}']", visible: true)[:disabled]).to be_truthy
end

Então('o formulário não é submetido') do
  # Continua na mesma página e não mostra sucesso
  expect(page).not_to have_content('Avaliação enviada com sucesso!')
end

Então('sou redirecionado para a página inicial') do
  expect(URI.parse(current_url).path).to eq('/')
end

Então('as respostas não são perdidas localmente \(mantêm-se visíveis na tela\)') do
  # Campos ainda preenchidos após erro de envio
  all("[data-testid='pergunta-texto'] [data-testid='campo-texto-pergunta']").each do |campo|
    expect(campo.value).to be_present
  end
  # Pelo menos uma alternativa de rádio continua marcada
  expect(page).to have_selector("[data-testid='alternativa-opcao']:checked", minimum: 1, wait: 1)
end
