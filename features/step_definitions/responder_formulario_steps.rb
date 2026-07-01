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
  fill_in 'Email ou Matrícula', with: 'participante@gmail.com'
  fill_in 'Senha', with: 'password123'
  click_button 'Entrar'
end

Dado('estou matriculado na turma {string} da disciplina {string}') do |class_code, disc_name|
  @disciplina = Disciplina.find_or_create_by!(name: disc_name)
  @turma = Turma.find_or_create_by!(classCode: class_code, disciplina: @disciplina) do |t|
    t.semester = '2026.1'
  end
  TurmaMembership.find_or_create_by!(turma: @turma, user: @user)
end

Dado('existe um formulário pendente para esta turma') do
  @template = Template.create!(nome: "Avaliação da Turma #{@turma.classCode}")
  @question = @template.questions.create!(
    kind: 'text',
    text: 'Avaliação do Professor',
    obrigatoria: true
  )
  @form = Form.create!(
    template:   @template,
    start_date: 1.day.ago,
    end_date:   1.week.from_now
  )
  @form.turmas << @turma
end

Quando('clico no botão {string} do formulário da turma {string}') do |botao, turma_code|
  formulario = Form.joins(:turmas).find_by(turmas: { classCode: turma_code })
  within("#formulario_#{formulario.id}") do
    click_link_or_button botao
  end
end

Quando('preencho todas as questões obrigatórias com valores válidos') do
  @form.template.questions.where(obrigatoria: true).each do |question|
    if question.kind == 'radio'
      choose('Sim')
    else
      fill_in "answers_#{question.id}", with: 'Ótimo professor'
    end
  end
end

Quando('clico no botão de formulário {string}') do |botao|
  click_button botao
end

Então('o card do formulário da turma {string} exibe o status {string}') do |turma_code, status|
  formulario = Form.joins(:turmas).find_by(turmas: { classCode: turma_code })
  within("#formulario_#{formulario.id}") do
    expect(page).to have_content(status)
  end
end

# Visualizar formulário já respondido
Dado('que já respondi ao formulário da turma {string}') do |turma_code|
  formulario = Form.joins(:turmas).find_by(turmas: { classCode: turma_code })
  FormResponse.create!(
    form:    formulario,
    user:    @user,
    turma:   @turma,
    answers: [{ "question_id" => formulario.template.questions.first.id, "value" => "Já respondi" }]
  )
end

Quando('tento clicar no botão {string} novamente') do |botao|
  visit avaliacoes_path
end

Então('o botão deve estar desabilitado') do
  expect(page).to have_button('Responder', disabled: true)
end

Então('vejo o texto {string}') do |texto|
  expect(page).to have_content(texto)
end

# Tentativa de submissão de formulário incompleto
Quando('deixo a questão obrigatória {string} em branco') do |enunciado|
  question = Question.find_by(text: enunciado)
  fill_in "answers_#{question.id}", with: ''
end

Então('permaneço na página do formulário') do
  expect(page).to have_content("Avaliação — #{@turma.classCode}")
end

Então('vejo o alerta {string}') do |alerta|
  expect(page).to have_content(alerta)
end

Então('a questão {string} é destacada em vermelho') do |enunciado|
  expect(page).to have_css('.highlight-red')
end

# Tentativa de responder formulário fora do prazo
Dado('que o prazo para o formulário da turma {string} expirou') do |turma_code|
  formulario = Form.joins(:turmas).find_by(turmas: { classCode: turma_code })
  formulario.update!(end_date: 1.day.ago)
end

Quando('acesso a página de {string}') do |page_name|
  step "estou na página de \"#{page_name}\""
end

Então('não vejo o botão {string} para a turma {string}') do |botao, turma_code|
  formulario = Form.joins(:turmas).find_by(turmas: { classCode: turma_code })
  within("#formulario_#{formulario.id}") do
    expect(page).not_to have_link(botao)
  end
end

# Erro ao enviar formulário por falha de conexão
Quando('perco a conexão com a internet') do
  allow(FormResponse).to receive(:create!).and_raise(StandardError.new("Falha na conexão. Tente novamente."))
end

Então('minhas respostas preenchidas devem ser preservadas localmente') do
  expect(find_field("answers_#{@question.id}").value).to eq('Ótimo professor')
end

Quando('preencho o formulário') do
  step 'preencho todas as questões obrigatórias com valores válidos'
end
