# encoding: utf-8

# ==================== CONTEXTO ====================

Dado('que existem turmas e templates para criação de formulários') do
  disciplina = Disciplina.find_or_create_by!(code: 'CIC0001') do |d|
    d.name = 'Engenharia de Software'
  end

  @turma_cic0105 = Turma.find_or_create_by!(classCode: 'CIC0105') do |t|
    t.disciplina = disciplina
    t.nome       = 'Engenharia de Software'
    t.semester   = '2026.1'
    t.time       = '10:00'
  end

  @turma_cic0202 = Turma.find_or_create_by!(classCode: 'CIC0202') do |t|
    t.disciplina = disciplina
    t.nome       = 'Engenharia de Software'
    t.semester   = '2026.1'
    t.time       = '14:00'
  end

  Template.find_or_create_by!(nome: 'Avaliação Engenharia de Software')
  Template.find_or_create_by!(nome: 'Avaliação de Didática')
end

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

Quando('seleciono a turma {string} no campo {string}') do |turma, campo|
  select_field = find_field(campo)
  select_field.find(:option, turma).select_option
end

Quando('preencho a data de início com {string}') do |data|
  fill_in 'data_inicio', with: Date.strptime(data, '%d/%m/%Y').strftime('%Y-%m-%d')
end

Quando('preencho a data de término com {string}') do |data|
  fill_in 'data_termino', with: Date.strptime(data, '%d/%m/%Y').strftime('%Y-%m-%d')
end

Quando('clico no campo {string} novamente para adicionar mais turmas') do |campo|
  # Em um <select multiple>, select_option já adiciona a nova opção sem
  # desmarcar as anteriores — nenhuma ação adicional é necessária aqui.
end

Quando('preencho as datas de vigência') do
  fill_in 'data_inicio', with: '2026-05-26'
  fill_in 'data_termino', with: '2026-06-01'
end

Quando('não seleciono nenhuma turma no campo {string}') do |campo|
  # Campo já começa sem seleção
  expect(find('#turma_ids').value).to eq([])
end

# ==================== CENÁRIOS FELIZES - VERIFICAÇÕES ====================

Então('o formulário fica disponível para os dicentes da turma {string}') do |turma|
  expect(Form.last.destinatario).to eq('discente')
  expect(Form.last.turmas.pluck(:classCode)).to include(turma)
end

Então('o formulário fica disponível para os docentes da turma {string}') do |turma|
  expect(Form.last.destinatario).to eq('docente')
  expect(Form.last.turmas.pluck(:classCode)).to include(turma)
end

Então('vejo a mensagem de sucesso {string} para {int} turmas') do |mensagem, quantidade|
  expect(page).to have_content(mensagem)
  expect(page).to have_content(quantidade)
end

Então('o formulário fica disponível para os dicentes das turmas {string} e {string}') do |turma1, turma2|
  expect(Form.last.turmas.pluck(:classCode)).to include(turma1, turma2)
end

Dado('que criei um formulário para dicentes da turma {string} com o template {string}') do |turma, nome_template|
  template = Template.find_by(nome: nome_template) || Template.create!(nome: nome_template)
  @form = Form.create!(
    template:     template,
    destinatario: 'discente',
    start_date:   1.day.ago,
    end_date:     1.day.from_now
  )
  @turma = Turma.find_by(classCode: turma)
  @form.turmas << @turma
end

Então('vejo na tabela uma linha com os dados do formulário criado') do
  expect(page).to have_selector('table')
  expect(page).to have_content(@form.template.nome)
  expect(page).to have_content(@turma.classCode)
end

Então('a linha contém {string}, {string}, {string} e as datas de vigência') do |destiny, turma, template|
  expect(page).to have_content(destiny)
  expect(page).to have_content(turma)
  expect(page).to have_content(template)
end

Dado('que um formulário foi criado para dicentes da turma {string}') do |turma|
  template = Template.find_by(nome: 'Avaliação de Engenharia de Software') || Template.create!(nome: 'Avaliação de Engenharia de Software')
  @form = Form.create!(
    template:     template,
    destinatario: 'discente',
    start_date:   1.day.ago,
    end_date:     1.day.from_now
  )
  @turma = Turma.find_by(classCode: turma)
  @form.turmas << @turma if @turma
end

Dado('que um formulário foi criado para docentes da turma {string}') do |turma|
  template = Template.find_by(nome: 'Avaliação de Didática') || Template.create!(nome: 'Avaliação de Didática')
  @form = Form.create!(
    template:     template,
    destinatario: 'docente',
    start_date:   1.day.ago,
    end_date:     1.day.from_now
  )
  @turma = Turma.find_by(classCode: turma)
  @form.turmas << @turma if @turma
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
  @dicente.turmas << @turma if @turma
  
  # Login como dicente
  visit login_path
  fill_in 'Email ou Matrícula', with: 'dicente@gmail.com'
  fill_in 'Senha', with: 'senhaDicente'
  click_button 'Entrar'
  
  # Acessa painel de Avaliações
  visit avaliacoes_path
end

Então('o dicente visualiza o card do formulário dentro do período de vigência') do
  expect(page).to have_selector('.turma-card')
  expect(page).to have_content(@form.template.nome)
end

Então('o card exibe o nome do template e a data de término') do
  expect(page).to have_content(@form.template.nome)
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
  @docente.turmas << @turma if @turma
  
  # Login como docente
  visit login_path
  fill_in 'Email ou Matrícula', with: 'docente@gmail.com'
  fill_in 'Senha', with: 'senhaDocente'
  click_button 'Entrar'
  
  # Acessa painel de Avaliações
  visit avaliacoes_path
end

Então('o docente visualiza o card do formulário dentro do período de vigência') do
  expect(page).to have_selector('.turma-card')
  expect(page).to have_content(@form.template.nome)
end

# ==================== CENÁRIOS TRISTES - VERIFICAÇÕES ====================

Então('o modal é exibido') do
  expect(page).to have_selector('.modal')
end

Quando('deixo os campos de data em branco') do
  fill_in 'data_inicio', with: ''
  fill_in 'data_termino', with: ''
end

Então('o campo {string} está vazio') do |campo|
  expect(find('#turma_ids')).not_to have_selector('option')
end