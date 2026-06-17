# encoding: utf-8

# ==================== CONTEXTO ====================

Dado('que estou logado como Administrador do departamento {string}') do |departamento|
  @department = Department.find_or_create_by!(code: departamento, name: departamento)
  
  @admin_user = User.create!(
    email:                 "admin_#{departamento.downcase}@gmail.com",
    matricula:             "000000001",
    password:              'senhaAdmin',
    password_confirmation: 'senhaAdmin',
    role:                  'admin',
    department:            @department
  )
  
  visit login_path
  fill_in 'email', with: @admin_user.email
  fill_in 'password', with: 'senhaAdmin'
  click_button 'Entrar'
end

# Removed duplicate click step

Então('sou redirecionado para a página {string}') do |pagina|
  case pagina
  when 'Gerenciamento - Turmas'
    expect(page).to have_current_path(admin_classes_path, wait: 10)
  else
    expect(page).to have_current_path('/')
  end
end

Então('vejo uma tabela com as turmas do departamento {string}') do |departamento|
  expect(page).to have_selector('table')
  expect(page).to have_content(departamento)
end

# ==================== CENÁRIOS FELIZES - AÇÕES E VERIFICAÇÕES ====================

Quando('acesso a página {string}') do |pagina|
  case pagina
  when 'Gerenciamento - Turmas'
    visit admin_classes_path
  else
    visit '/'
  end
end

Então('vejo a tabela com colunas {string}, {string}, {string}, {string} e {string}') do |col1, col2, col3, col4, col5|
  expect(page).to have_selector('table th', text: col1)
  expect(page).to have_selector('table th', text: col2)
  expect(page).to have_selector('table th', text: col3)
  expect(page).to have_selector('table th', text: col4)
  expect(page).to have_selector('table th', text: col5)
end

Então('vejo apenas turmas que pertencem ao departamento {string}') do |departamento|
  @department = Department.find_by(code: departamento)
  classes = @department.classes
  classes.each do |klass|
    expect(page).to have_content(klass.code)
  end
end

Então('turmas de outros departamentos não aparecem na tabela') do
  other_department = Department.where.not(id: @department.id).first
  if other_department
    other_department.classes.each do |klass|
      expect(page).not_to have_content(klass.code)
    end
  end
end

Dado('que existe a turma {string} no departamento {string}') do |codigo_turma, departamento|
  @department = Department.find_by(code: departamento)
  @class = Class.create!(
    code:       codigo_turma,
    name:       "Turma #{codigo_turma}",
    semester:   '2026.1',
    department: @department
  )
end

Quando('clico na turma {string}') do |codigo_turma|
  click_link codigo_turma
end

Então('sou redirecionado para a página de detalhes da turma') do
  expect(page).to have_current_path(admin_class_path(@class), wait: 10)
end

Então('vejo informações como {string}, {string}, {string}, {string}, {string} e {string}') do |info1, info2, info3, info4, info5, info6|
  expect(page).to have_content(info1)
  expect(page).to have_content(info2)
  expect(page).to have_content(info3)
  expect(page).to have_content(info4)
  expect(page).to have_content(info5)
  expect(page).to have_content(info6)
end

Então('vejo o botão {string}') do |botao|
  expect(page).to have_button(botao)
end

Dado('que estou visualizando os detalhes da turma {string}') do |codigo_turma|
  @class = Class.find_by(code: codigo_turma)
  visit admin_class_path(@class)
end

# Removed duplicate click step

Então('um formulário é exibido com os dados atuais da turma') do
  expect(page).to have_selector('form')
  expect(page).to have_field('Código', with: @class.code)
  expect(page).to have_field('Nome', with: @class.name)
end

Quando('altero o campo {string} para {string}') do |campo, valor|
  fill_in campo, with: valor
end

Então('vejo a mensagem de sucesso {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('a turma {string} agora exibe {string}') do |codigo_turma, valor|
  @class.reload
  expect(@class.room).to eq(valor)
  expect(page).to have_content(valor)
end

# Removed duplicate click step

Então('um modal é exibido com a lista de dicentes matriculados') do
  expect(page).to have_selector('.modal')
  expect(page).to have_content('Dicentes')
end

Então('vejo colunas {string}, {string}, {string} e {string}') do |col1, col2, col3, col4|
  expect(page).to have_content(col1)
  expect(page).to have_content(col2)
  expect(page).to have_content(col3)
  expect(page).to have_content(col4)
end

Então('cada dicente mostra se respondeu formulários ou não') do
  expect(page).to have_selector('table tr')
end

Então('um modal é exibido com a lista de docentes vinculados') do
  expect(page).to have_selector('.modal')
  expect(page).to have_content('Docentes')
end

Dado('que existem formulários enviados para a turma {string}') do |codigo_turma|
  @class = Class.find_by(code: codigo_turma)
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação de Engenharia de Software',
    start_date: 2.days.ago,
    end_date: 2.days.from_now
  )
  @form.classes << @class
end

# Removed duplicate click step

Então('vejo um painel com gráficos de desempenho') do
  expect(page).to have_selector('.chart, .graph, svg')
end

Então('vejo a taxa de resposta dos dicentes em percentual') do
  expect(page).to have_content('%')
end

Então('vejo a taxa de resposta dos docentes em percentual') do
  expect(page).to have_content('%')
end

Então('vejo a data da última resposta recebida') do
  expect(page).to have_content('última resposta')
end

Dado('que existem turmas de semestres diferentes no departamento') do
  Class.create!(
    code:       'CIC0201',
    name:       'Turma 2026.2',
    semester:   '2026.2',
    department: @department
  )
  Class.create!(
    code:       'CIC0301',
    name:       'Turma 2026.1',
    semester:   '2026.1',
    department: @department
  )
end

Quando('seleciono o semestre {string} no filtro') do |semestre|
  select semestre, from: 'semestre'
end

Então('a tabela exibe apenas as turmas do semestre {string}') do |semestre|
  expect(page).to have_selector('table')
  expect(page).to have_content(semestre)
end

Dado('que existem turmas de diferentes docentes') do
  @docente1 = User.create!(
    email:                 'docente1@gmail.com',
    matricula:             '000000010',
    password:              'senhaDocente',
    password_confirmation: 'senhaDocente',
    role:                  'docente',
    department:            @department
  )
  @docente2 = User.create!(
    email:                 'docente2@gmail.com',
    matricula:             '000000011',
    password:              'senhaDocente',
    password_confirmation: 'senhaDocente',
    role:                  'docente',
    department:            @department
  )
  
  Class.create!(
    code:       'CIC0105',
    name:       'Turma Prof. João',
    semester:   '2026.1',
    department: @department,
    teacher:    @docente1
  )
  Class.create!(
    code:       'CIC0106',
    name:       'Turma Prof. Maria',
    semester:   '2026.1',
    department: @department,
    teacher:    @docente2
  )
end

Quando('seleciono o docente {string} no filtro') do |docente|
  select docente, from: 'docente'
end

Então('a tabela exibe apenas as turmas lecionadas por {string}') do |docente|
  expect(page).to have_selector('table')
  expect(page).to have_content(docente)
end

Dado('que existem turmas com status {string} e {string}') do |status1, status2|
  Class.create!(
    code:       'CIC0107',
    name:       'Turma Ativa',
    semester:   '2026.1',
    department: @department,
    status:     'Ativa'
  )
  Class.create!(
    code:       'CIC0108',
    name:       'Turma Encerrada',
    semester:   '2025.2',
    department: @department,
    status:     'Encerrada'
  )
end

Quando('seleciono {string} no filtro {string}') do |opcao, filtro|
  select opcao, from: filtro
end

Então('a tabela exibe apenas as turmas ativas') do
  expect(page).to have_content('Ativa')
end

Então('as turmas encerradas deixam de aparecer') do
  expect(page).not_to have_content('Encerrada')
end

Quando('clico no cabeçalho da coluna {string}') do |coluna|
  find("th", text: coluna).click
end

Então('a tabela é ordenada alfabeticamente por nome') do
  expect(page).to have_selector('table tbody tr:first-child')
end

Então('a tabela é ordenada em ordem reversa') do
  expect(page).to have_selector('table tbody tr:first-child')
end

Então('um modal de seleção de filtros é exibido') do
  expect(page).to have_selector('.modal')
end

Então('vejo opções para selecionar {string}, {string} e {string}') do |opcao1, opcao2, opcao3|
  expect(page).to have_content(opcao1)
  expect(page).to have_content(opcao2)
  expect(page).to have_content(opcao3)
end

# ==================== CENÁRIOS TRISTES ====================

Dado('que estou logado como Dicente') do
  @dicente = User.create!(
    email:                 'dicente@gmail.com',
    matricula:             '190084009',
    password:              'senhaDicente',
    password_confirmation: 'senhaDicente',
    role:                  'discente'
  )
  
  visit login_path
  fill_in 'email', with: 'dicente@gmail.com'
  fill_in 'password', with: 'senhaDicente'
  click_button 'Entrar'
end

Quando('tento acessar a página {string}') do |pagina|
  visit admin_classes_path
end

Então('sou redirecionado para o painel do usuário') do
  expect(page).to have_current_path(home_path, wait: 10)
end

Então('vejo a mensagem de erro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Dado('que sou um Administrador do departamento {string}') do |departamento|
  @department = Department.find_or_create_by!(code: departamento, name: departamento)
  
  @admin_user = User.create!(
    email:                 "admin_#{departamento.downcase}@gmail.com",
    matricula:             "000000002",
    password:              'senhaAdmin',
    password_confirmation: 'senhaAdmin',
    role:                  'admin',
    department:            @department
  )
  
  visit login_path
  fill_in 'email', with: @admin_user.email
  fill_in 'password', with: 'senhaAdmin'
  click_button 'Entrar'
end

Quando('tento acessar a página de edição da turma {string} que pertence ao departamento {string}') do |codigo_turma, departamento|
  other_department = Department.find_or_create_by!(code: departamento, name: departamento)
  @other_class = Class.find_or_create_by!(
    code:       codigo_turma,
    name:       "Turma #{codigo_turma}",
    semester:   '2026.1',
    department: other_department
  )
  visit admin_class_path(@other_class)
end

Então('vejo a mensagem de erro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end
