# features/step_definitions/responder_formulario_steps.rb

# ── CONTEXTO / DADO ───────────────────────────────────────────────────────────

Dado("que eu estou logado no sistema CAMAAR com o perfil de {string}") do |perfil|
  case perfil
  when "discente"
    @usuario  = create(:usuario, perfil: :discente, primeiro_acesso: false)
    @discente = create(:discente, usuario: @usuario)
  when "docente"
    @usuario = create(:usuario, perfil: :docente, primeiro_acesso: false)
    @docente = create(:docente, usuario: @usuario, departamento: create(:departamento))
  end

  visit login_path
  fill_in "Login", with: @usuario.login
  fill_in "Senha", with: "Senha123!"
  click_button "Entrar"
  expect(page).to have_current_path(root_path)
end

Dado("que eu não estou logado no sistema") do
  # não faz login — sessão vazia
end

Dado("estou matriculado na turma {string}") do |nome_turma|
  @turma = encontrar_ou_criar_turma(nome_turma)
  create(:matricula, discente: @discente, turma: @turma)
end

Dado("existe um formulário de avaliação disponível para a turma {string}") do |nome_turma|
  @turma       ||= encontrar_ou_criar_turma(nome_turma)
  @docente     ||= create(:docente, usuario: create(:usuario, perfil: :docente),
                           departamento: create(:departamento))
  @template    = create(:template, docente: @docente)
  @questao_txt = create(:questao_template, template: @template, tipo: :aberta,
                          enunciado: "Deixe seu comentário sobre a disciplina")
  @questao_rad = create(:questao_template, template: @template, tipo: :multipla,
                          enunciado: "Como você avalia o docente?")
  create(:opcao_questao, questao_template: @questao_rad, texto: "Ótimo")
  create(:opcao_questao, questao_template: @questao_rad, texto: "Bom")
  create(:opcao_questao, questao_template: @questao_rad, texto: "Regular")

  @formulario = create(:formulario, turma: @turma, template: @template,
                        titulo: "Avaliação Docente 2024.1", prazo: 7.days.from_now)
  # instancia questões no formulário
  @q1 = create(:questao, formulario: @formulario, questao_template: @questao_txt,
                enunciado: @questao_txt.enunciado, tipo: :aberta)
  @q2 = create(:questao, formulario: @formulario, questao_template: @questao_rad,
                enunciado: @questao_rad.enunciado, tipo: :multipla)
end

Dado("que o formulário contém uma questão do tipo {string} e uma do tipo {string}") do |_tipo1, _tipo2|
  # as questões já foram criadas no passo anterior — nada a fazer
end

Dado("que o formulário contém questões obrigatórias") do
  # questões já criadas — todas são obrigatórias por definição
end

Dado("que já respondi o formulário de avaliação da turma {string}") do |nome_turma|
  @turma ||= encontrar_ou_criar_turma(nome_turma)

  # garante que formulário e questões existam
  unless @formulario
    step "existe um formulário de avaliação disponível para a turma \"#{nome_turma}\""
  end

  @envio = create(:envio_formulario, formulario: @formulario, discente: @discente,
                   enviado_em: Time.current)
  create(:resposta, envio_formulario: @envio, questao: @q1,
         conteudo: "Ótima disciplina")
  create(:resposta, envio_formulario: @envio, questao: @q2,
         conteudo: "Ótimo")
end

Dado("que o formulário de avaliação da turma {string} está encerrado") do |nome_turma|
  @turma ||= encontrar_ou_criar_turma(nome_turma)
  unless @formulario
    step "existe um formulário de avaliação disponível para a turma \"#{nome_turma}\""
  end
  @formulario.update!(prazo: 2.days.ago)
end

Dado("existe um formulário disponível para a turma {string}") do |nome_turma|
  turma_outra = encontrar_ou_criar_turma(nome_turma)
  @docente  ||= create(:docente, usuario: create(:usuario, perfil: :docente),
                        departamento: create(:departamento))
  template   = create(:template, docente: @docente)
  @formulario_outro = create(:formulario, turma: turma_outra, template: template,
                               titulo: "Formulário outra turma", prazo: 7.days.from_now)
end

Dado("eu não estou matriculado na turma {string}") do |_nome_turma|
  # discente não tem matrícula nessa turma — estado padrão
end

# ── QUANDO ───────────────────────────────────────────────────────────────────

Quando("eu acesso o formulário e preencho todas as questões") do
  visit formulario_path(@formulario)
  click_link "Responder →"

  # preenche questão aberta
  within "[data-questao-id='#{@q1.id}']" do
    fill_in "resposta[questao_#{@q1.id}]", with: "Ótima disciplina, recomendo!"
  end

  # seleciona opção de múltipla escolha
  within "[data-questao-id='#{@q2.id}']" do
    choose "Ótimo"
  end
end

Quando("eu acesso o formulário e deixo uma questão sem resposta") do
  visit formulario_path(@formulario)
  click_link "Responder →"
  # preenche apenas a primeira, deixa a segunda em branco
  within "[data-questao-id='#{@q1.id}']" do
    fill_in "resposta[questao_#{@q1.id}]", with: "Comentário parcial"
  end
  # não preenche @q2
end

Quando("eu acesso o formulário respondido") do
  visit formulario_path(@formulario)
end

Quando("eu tento acessar o formulário novamente para responder") do
  visit formulario_path(@formulario)
end

Quando("eu tento acessar o formulário para responder") do
  visit formulario_path(@formulario)
end

Quando("eu tento acessar o formulário diretamente pela URL") do
  visit formulario_path(@formulario_outro)
end

Quando("eu tento acessar a página de resposta de um formulário") do
  formulario_qualquer = create(:formulario,
    turma: create(:turma, disciplina: create(:disciplina),
                           docente: create(:docente,
                             usuario: create(:usuario, perfil: :docente),
                             departamento: create(:departamento))),
    template: create(:template,
      docente: create(:docente,
        usuario: create(:usuario, perfil: :docente),
        departamento: create(:departamento))))
  visit new_envio_formulario_path(formulario_id: formulario_qualquer.id)
end

Quando("clico em {string}") do |botao|
  click_button botao
end

# ── ENTÃO ─────────────────────────────────────────────────────────────────────

Então("o sistema deve registrar meu envio com sucesso") do
  expect(EnvioFormulario.where(formulario: @formulario, discente: @discente)).to exist
  expect(Resposta.joins(:envio_formulario)
    .where(envio_formularios: { formulario: @formulario, discente: @discente }).count).to eq(2)
end

Então("devo ver a mensagem {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end

Então("devo ser redirecionado para o meu dashboard") do
  expect(page).to have_current_path(root_path)
end

Então("devo ser redirecionado para a lista de formulários") do
  expect(page).to have_current_path(formularios_path)
end

Então("devo ser redirecionado para a página de login") do
  expect(page).to have_current_path(login_path)
end

Então("devo ver minhas respostas em modo somente leitura") do
  expect(page).to have_content("Esta é sua resposta enviada")
  expect(page).not_to have_field("resposta")
  expect(page).not_to have_button("Enviar Respostas")
end

Então("não devo ver o botão {string}") do |botao|
  expect(page).not_to have_button(botao)
end

Então("o formulário não deve ser submetido") do
  expect(EnvioFormulario.where(formulario: @formulario, discente: @discente)).not_to exist
end

# ── HELPER ───────────────────────────────────────────────────────────────────

def encontrar_ou_criar_turma(nome_turma)
  codigo = nome_turma.split(" - ").first.strip
  disciplina = Disciplina.find_by(codigo: codigo) ||
               create(:disciplina, codigo: codigo,
                       nome: nome_turma.split(" - ").last.strip)
  docente = @docente || create(:docente,
              usuario: create(:usuario, perfil: :docente),
              departamento: create(:departamento))
  Turma.find_by(codigo: "TA", disciplina: disciplina) ||
    create(:turma, codigo: "TA", semestre: "2021.2",
            disciplina: disciplina, docente: docente)
end
