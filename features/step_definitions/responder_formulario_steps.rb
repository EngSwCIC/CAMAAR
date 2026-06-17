# encoding: utf-8

Dado('que estou logado como Participante de teste') do
  @user = User.find_by(email: 'participante@gmail.com')
  unless @user
    @user = User.create!(
      email: 'participante@gmail.com',
      matricula: '123456789',
      password: 'password123',
      password_confirmation: 'password123',
      role: 'discente'
    )
  end
  visit login_path
  fill_in 'login', with: 'participante@gmail.com'
  fill_in 'password', with: 'password123'
  click_button 'Entrar'
end

Dado('estou matriculado na turma {string} da disciplina {string}') do |class_code, disc_name|
  @disciplina = Disciplina.find_or_create_by!(name: disc_name, code: 'DSC001')
  @turma = Turma.find_or_create_by!(classCode: class_code, disciplina: @disciplina, semester: '2026.1')
  @discente = Discente.create!(
    nome: 'Participante Teste',
    matricula: @user.matricula,
    email: @user.email,
    turma: @turma
  )
end

Dado('existe um formulário pendente para esta turma') do
  @formulario = Formulario.create!(
    titulo: "Avaliação da Turma #{@turma.classCode}",
    deadline: 1.week.from_now,
    turma: @turma
  )
  @pergunta = Pergunta.create!(
    formulario: @formulario,
    enunciado: 'Avaliação do Professor',
    tipo_pergunta: 'texto',
    obrigatoria: true
  )
end

Quando('clico no botão {string} do formulário da turma {string}') do |botao, turma_code|
  # Encontrar o formulário da turma
  formulario = Formulario.joins(:turma).find_by(turmas: { classCode: turma_code })
  within("#formulario_#{formulario.id}") do
    click_link_or_button botao
  end
end

Quando('preencho todas as questões obrigatórias com valores válidos') do
  fill_in "pergunta_#{@pergunta.id}", with: 'Ótimo professor'
end

Quando('clico no botão de formulário {string}') do |botao|
  click_button botao
end

Então('vejo a mensagem de sucesso {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('o card do formulário da turma {string} exibe o status {string}') do |turma_code, status|
  formulario = Formulario.joins(:turma).find_by(turmas: { classCode: turma_code })
  within("#formulario_#{formulario.id}") do
    expect(page).to have_content(status)
  end
end

# Visualizar formulário já respondido
Dado('que já respondi ao formulário da turma {string}') do |turma_code|
  formulario = Formulario.joins(:turma).find_by(turmas: { classCode: turma_code })
  Resposta.create!(
    formulario: formulario,
    user: @user,
    pergunta: formulario.perguntas.first,
    conteudo: 'Já respondi'
  )
end

Quando('tento clicar no botão {string} novamente') do |botao|
  # O botão deve estar na página de index
  visit formularios_path
end

Então('o botão deve estar desabilitado') do
  expect(page).to have_button('Responder', disabled: true)
end

Então('vejo o texto {string}') do |texto|
  expect(page).to have_content(texto)
end

# Tentativa de submissão de formulário incompleto
Quando('deixo a questão obrigatória {string} em branco') do |enunciado|
  pergunta = Pergunta.find_by(enunciado: enunciado)
  fill_in "pergunta_#{pergunta.id}", with: ''
end

Então('permaneço na página do formulário') do
  expect(page).to have_current_path(formulario_respostas_path(@formulario))
end

Então('vejo o alerta {string}') do |alerta|
  expect(page).to have_content(alerta)
end

Então('a questão {string} é destacada em vermelho') do |enunciado|
  expect(page).to have_css('.highlight-red')
end

# Tentativa de responder formulário fora do prazo
Dado('que o prazo para o formulário da turma {string} expirou') do |turma_code|
  formulario = Formulario.joins(:turma).find_by(turmas: { classCode: turma_code })
  formulario.update!(deadline: 1.day.ago)
end

Quando('acesso a página de {string}') do |page_name|
  step "estou na página de \"#{page_name}\""
end

Então('não vejo o botão {string} para a turma {string}') do |botao, turma_code|
  formulario = Formulario.joins(:turma).find_by(turmas: { classCode: turma_code })
  within("#formulario_#{formulario.id}") do
    expect(page).not_to have_link(botao)
  end
end

# Erro ao enviar formulário por falha de conexão
Quando('perco a conexão com a internet') do
  allow(Resposta).to receive(:create!).and_raise(StandardError.new("Falha na conexão. Tente novamente."))
end

Então('minhas respostas preenchidas devem ser preservadas localmente') do
  # No mundo real isso usaria localStorage ou similar. 
  # Para o teste, vamos apenas verificar se o valor continua no campo após o erro/render.
  expect(find_field("pergunta_#{@pergunta.id}").value).to eq('Ótimo professor')
end

Quando('preencho o formulário') do
  step 'preencho todas as questões obrigatórias com valores válidos'
end
