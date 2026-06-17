# encoding: utf-8

# ==================== CONTEXTO ====================

# Removed duplicate navigation step


Então('um modal é exibido com os campos {string}, {string}, {string} e data de disponibilidade') do |campo1, campo2, campo3|
  expect(page).to have_selector('.modal')
  expect(page).to have_field(campo1)
  expect(page).to have_field(campo2)
  expect(page).to have_field(campo3)
end

# ==================== CENÁRIOS FELIZES - AÇÕES ====================

Quando('seleciono {string} no campo {string}') do |opcao, campo|
  select opcao, from: campo
end

Quando('seleciono o template {string} no dropdown {string}') do |template, campo|
  select template, from: campo
end

Quando('seleciono a turma {string} no campo {string}') do |turma, campo|
  select turma, from: campo
end

Quando('preencho a data de início com {string}') do |data|
  fill_in 'data_inicio', with: data
end

Quando('preencho a data de término com {string}') do |data|
  fill_in 'data_termino', with: data
end

Quando('clico no campo {string} novamente para adicionar mais turmas') do |campo|
  # Simula clique adicional em campo multi-select
  find("select[name='#{campo.downcase.gsub(/\s+/, '_')}']").click
end

Quando('preencho as datas de vigência') do
  fill_in 'data_inicio', with: '26/05/2026'
  fill_in 'data_termino', with: '01/06/2026'
end

Quando('deixo o campo {string} em branco') do |campo|
  fill_in campo, with: ''
end

Quando('não seleciono nenhum template no dropdown {string}') do |campo|
  # Campo já começa sem seleção
  expect(find("select[name='#{campo.downcase.gsub(/\s+/, '_')}']").value).to be_nil
end

Quando('não seleciono nenhuma turma no campo {string}') do |campo|
  # Campo já começa sem seleção
  expect(find("select[name='#{campo.downcase.gsub(/\s+/, '_')}']").value).to be_nil
end

# ==================== CENÁRIOS FELIZES - VERIFICAÇÕES ====================

Então('o modal é fechado') do
  expect(page).not_to have_selector('.modal')
end

Então('vejo a mensagem de sucesso {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('o formulário fica disponível para os dicentes da turma {string}') do |turma|
  # Verifica se o formulário foi criado e associado à turma
  expect(Form.last.destiny_type).to eq('discente')
  expect(Form.last.classes.pluck(:code)).to include(turma)
end

Então('o formulário fica disponível para os docentes da turma {string}') do |turma|
  # Verifica se o formulário foi criado e associado à turma
  expect(Form.last.destiny_type).to eq('docente')
  expect(Form.last.classes.pluck(:code)).to include(turma)
end

Então('vejo a mensagem de sucesso {string} para {int} turmas') do |mensagem, quantidade|
  expect(page).to have_content(mensagem)
  expect(page).to have_content(quantidade)
end

Então('o formulário fica disponível para os dicentes das turmas {string} e {string}') do |turma1, turma2|
  expect(Form.last.classes.pluck(:code)).to include(turma1, turma2)
end

Dado('que criei um formulário para dicentes da turma {string} com o template {string}') do |turma, template|
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: template,
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @turma = Class.find_by(code: turma)
  @form.classes << @turma
end

Então('vejo na tabela uma linha com os dados do formulário criado') do
  expect(page).to have_selector('table')
  expect(page).to have_content(@form.template_name)
  expect(page).to have_content(@turma.code)
end

Então('a linha contém {string}, {string}, {string} e as datas de vigência') do |destiny, turma, template|
  expect(page).to have_content(destiny)
  expect(page).to have_content(turma)
  expect(page).to have_content(template)
end

Dado('que um formulário foi criado para dicentes da turma {string}') do |turma|
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação de Engenharia de Software',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @turma = Class.find_by(code: turma)
  @form.classes << @turma if @turma
end

Dado('que um formulário foi criado para docentes da turma {string}') do |turma|
  @form = Form.create!(
    destiny_type: 'docente',
    template_name: 'Avaliação de Didática',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @turma = Class.find_by(code: turma)
  @form.classes << @turma if @turma
end

Então('um Dicente matriculado na turma {string} acessa o painel de Avaliações') do |turma|
  @dicente = User.create!(
    email:                 'dicente@gmail.com',
    matricula:             '190084007',
    password:              'senhaDicente',
    password_confirmation: 'senhaDicente',
    role:                  'discente'
  )
  # Associa dicente à turma
  @dicente.classes << @turma if @turma
  
  # Login como dicente
  visit login_path
  fill_in 'email', with: 'dicente@gmail.com'
  fill_in 'password', with: 'senhaDicente'
  click_button 'Entrar'
  
  # Acessa painel de Avaliações
  visit avaliacoes_path
end

Então('o dicente visualiza o card do formulário dentro do período de vigência') do
  expect(page).to have_selector('.form-card')
  expect(page).to have_content(@form.template_name)
end

Então('o card exibe o nome do template e a data de término') do
  expect(page).to have_content(@form.template_name)
  expect(page).to have_content(@form.end_date.strftime('%d/%m/%Y'))
end

Então('um Docente vinculado à turma {string} acessa o painel de Avaliações') do |turma|
  @docente = User.create!(
    email:                 'docente@gmail.com',
    matricula:             '190084008',
    password:              'senhaDocente',
    password_confirmation: 'senhaDocente',
    role:                  'docente'
  )
  # Associa docente à turma
  @docente.classes << @turma if @turma
  
  # Login como docente
  visit login_path
  fill_in 'email', with: 'docente@gmail.com'
  fill_in 'password', with: 'senhaDocente'
  click_button 'Entrar'
  
  # Acessa painel de Avaliações
  visit avaliacoes_path
end

Então('o docente visualiza o card do formulário dentro do período de vigência') do
  expect(page).to have_selector('.form-card')
  expect(page).to have_content(@form.template_name)
end

# ==================== CENÁRIOS TRISTES - VERIFICAÇÕES ====================

Então('o modal permanece aberto') do
  expect(page).to have_selector('.modal')
end

Então('vejo a mensagem de erro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('a data de término anterior à data de início') do
  fill_in 'data_termino', with: '20/05/2026'
end
