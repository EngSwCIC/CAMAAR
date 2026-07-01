require 'securerandom'

SENHA_DISCENTE_RESP = "senha123".freeze

# ─── Helpers ──────────────────────────────────────────────────────────────────

def fazer_login_discente_resp(email)
  visit login_path
  fill_in "E-mail ou matrícula", with: email
  fill_in "Senha", with: SENHA_DISCENTE_RESP
  click_button "Entrar"
end

def parsear_turma_str(turma_str)
  partes = turma_str.split(" - ", 2).map(&:strip)
  { codigo: partes[0], nome: partes[1] || partes[0] }
end

def criar_grafo_formulario(turma_str)
  dados = parsear_turma_str(turma_str)

  @departamento = Departamento.create!(nome: "Dept BDD #{SecureRandom.hex(4)}")

  # Docente para o Template (modelo original BDD)
  usuario_docente = Usuario.create!(
    login: "docente_#{SecureRandom.hex(4)}",
    email: "docente_#{SecureRandom.hex(4)}@camaar.com",
    nome: "Docente BDD",
    perfil: :docente,
    password: SENHA_DISCENTE_RESP
  )
  @docente = Docente.create!(usuario: usuario_docente, departamento: @departamento)

  # Turma com schema Team B (departamento + codigo + nome)
  @turma = Turma.create!(
    codigo: dados[:codigo],
    nome: dados[:nome],
    departamento: @departamento
  )

  # Discente (modelo original BDD: belongs_to :usuario, has_many :matriculas)
  usuario_discente = Usuario.create!(
    login: "discente_#{SecureRandom.hex(4)}",
    email: "discente_#{SecureRandom.hex(4)}@camaar.com",
    nome: "Discente BDD",
    perfil: :discente,
    password: SENHA_DISCENTE_RESP
  )
  @discente = Discente.create!(
    usuario: usuario_discente,
    matricula: SecureRandom.random_number(10_000_000..99_999_999).to_s,
    curso: "Ciência da Computação"
  )
  Matricula.create!(discente: @discente, turma: @turma)

  # Template e questões (modelo original BDD)
  @template = Template.create!(titulo: "Avaliação BDD #{dados[:nome]}", docente: @docente)

  questao_template = QuestaoTemplate.create!(
    enunciado: "Avaliação do Docente",
    tipo: :aberta,
    template: @template
  )

  @formulario = Formulario.create!(
    titulo: "Avaliação - #{dados[:nome]}",
    turma: @turma,
    template: @template,
    prazo: 7.days.from_now
  )

  @questao_principal = Questao.create!(
    formulario: @formulario,
    questao_template: questao_template,
    enunciado: "Avaliação do Docente",
    tipo: :aberta
  )

  # User para autenticação via SessionsController (usa User, não Usuario)
  @auth_user = User.create!(
    nome: usuario_discente.nome,
    email: usuario_discente.email,
    matricula: @discente.matricula,
    perfil: "Discente",
    password: SENHA_DISCENTE_RESP,
    password_confirmation: SENHA_DISCENTE_RESP,
    primeiro_acesso: false
  )

  @auth_user
end

# ─── DADO: logado como discente e matriculado na turma ───────────────────────

Dado("que eu estou logado no sistema CAMAAR como {string} e matriculado na turma {string}") do |_perfil, turma_str|
  criar_grafo_formulario(turma_str)
  fazer_login_discente_resp(@auth_user.email)
end

# ─── DADO: já enviou o formulário anteriormente ──────────────────────────────

Dado("eu já enviei o formulário de avaliação desta turma anteriormente") do
  @envio = EnvioFormulario.create!(
    formulario: @formulario,
    discente: @discente,
    enviado_em: 1.hour.ago
  )
  Resposta.create!(
    envio_formulario: @envio,
    questao: @questao_principal,
    conteudo: "Ótimo professor"
  )
end

# ─── E: na página de resposta do formulário ──────────────────────────────────

E("eu estou na página de resposta do formulário desta turma") do
  visit new_envio_formulario_path(formulario_id: @formulario.id)
end

# ─── QUANDO: preenche todas as perguntas com respostas válidas ───────────────

Quando("eu preencho todas as perguntas com respostas válidas") do
  @formulario.questoes.each do |questao|
    if questao.aberta?
      fill_in "respostas[#{questao.id}]", with: "Resposta válida"
    else
      opcao = questao.opcao_questoes.first
      choose "respostas[#{questao.id}]_#{opcao.id}" if opcao
    end
  end
end

# ─── E/QUANDO: envio ─────────────────────────────────────────────────────────

E("eu envio o formulário") do
  click_button "Enviar avaliação"
end

Quando("eu tento enviar o formulário") do
  click_button "Enviar avaliação"
end

# ─── QUANDO: deixa campo obrigatório em branco ───────────────────────────────

Quando("eu deixo a pergunta {string} em branco") do |_enunciado|
  # não preenche nada — o formulário permanece vazio
end

# ─── QUANDO: insere nota fora do intervalo ───────────────────────────────────

Quando("eu insiro o valor {string} em uma das perguntas de nota") do |valor|
  fill_in "respostas[#{@questao_principal.id}]", with: valor
end

# ─── QUANDO: tenta acessar formulário já respondido ──────────────────────────

Quando("eu tento acessar diretamente à página de resposta deste formulário") do
  visit new_envio_formulario_path(formulario_id: @formulario.id)
end

# ─── ENTÃO: mensagem de erro ─────────────────────────────────────────────────
# Nota: "o sistema deve exibir a mensagem {string}" já definido em visualizar_templates_steps.rb

Então("o sistema deve exibir a mensagem de erro {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end

# ─── ENTÃO: formulário não aparece mais nos pendentes ────────────────────────

Então("o formulário deve deixar de aparecer na minha lista de pendentes") do
  visit formularios_path
  expect(page).to have_content("Nenhum formulário pendente")
end

# ─── ENTÃO: formulário não foi computado como respondido ─────────────────────

Então("o formulário não deve ser computado como respondido") do
  expect(EnvioFormulario.exists?(formulario: @formulario, discente: @discente)).to be(false)
end

# ─── ENTÃO: não permite nova submissão ───────────────────────────────────────

Então("por fim não deve permitir nova submissão") do
  count_antes = EnvioFormulario.where(formulario: @formulario).count
  visit formulario_path(@formulario)
  expect(EnvioFormulario.where(formulario: @formulario).count).to eq(count_antes)
end
