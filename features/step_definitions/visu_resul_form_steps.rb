# encoding: utf-8

# ==================== CONTEXTO ====================

# Removed duplicate auth step

# Removed duplicate navigation step

# Removed duplicate click step


Então('sou redirecionado para a página {string}') do |pagina|
  case pagina
  when 'Gerenciamento - Resultados'
    expect(page).to have_current_path(admin_results_path, wait: 10)
  else
    expect(page).to have_current_path('/')
  end
end

Então('vejo uma tabela com os formulários enviados') do
  expect(page).to have_selector('table')
end

# ==================== CENÁRIOS FELIZES - AÇÕES ====================

Quando('acesso a página {string}') do |pagina|
  case pagina
  when 'Gerenciamento - Resultados'
    visit admin_results_path
  else
    visit '/'
  end
end

Então('vejo uma tabela com as colunas {string}, {string}, {string}, {string} e {string}') do |col1, col2, col3, col4, col5|
  expect(page).to have_selector('table th', text: col1)
  expect(page).to have_selector('table th', text: col2)
  expect(page).to have_selector('table th', text: col3)
  expect(page).to have_selector('table th', text: col4)
  expect(page).to have_selector('table th', text: col5)
end

Então('cada linha exibe as informações do formulário enviado') do
  expect(page).to have_selector('table tbody tr')
end

Então('vejo o botão {string} em cada linha') do |botao|
  all('table tbody tr').each do |row|
    expect(row).to have_button(botao)
  end
end

Dado('que existem formulários com respostas já registradas') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @dicente = User.create!(
    email:                 'dicente@gmail.com',
    matricula:             '190084014',
    password:              'senha',
    password_confirmation: 'senha',
    role:                  'discente'
  )
  @dicente.classes << @class
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação de Engenharia de Software',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form.classes << @class
  
  # Cria respostas
  @response = FormResponse.create!(
    form: @form,
    user: @dicente,
    status: 'submitted',
    answers: {
      'q1' => 'Excelente',
      'q2' => 'O professor foi muito didático'
    }
  )
end

Quando('clico no botão {string} de um formulário') do |botao|
  click_button botao
end

Então('um modal é exibido com o nome do template') do
  expect(page).to have_selector('.modal')
  expect(page).to have_content(@form.template_name)
end

Então('vejo a quantidade total de respostas recebidas') do
  expect(page).to have_content('1')
end

Então('vejo as questões do formulário com o resumo das respostas') do
  expect(page).to have_content('Questão')
end

Então('as questões do tipo {string} exibem um gráfico com as opções e seus percentuais') do |tipo|
  if tipo == 'Radio'
    expect(page).to have_selector('canvas, svg')
  end
end

Então('as questões do tipo {string} exibem as respostas em formato de lista') do |tipo|
  if tipo == 'Texto'
    expect(page).to have_selector('ul, li')
  end
end

Dado('que abri os detalhes de um formulário com questões do tipo Radio') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação Didática',
    start_date: 1.day.ago,
    end_date: 1.day.from_now,
    questions: [
      { type: 'radio', text: 'Como você avalia a didática do professor?', options: ['Excelente', 'Bom', 'Regular', 'Ruim'] }
    ]
  )
  @form.classes << @class
  
  @dicentes = 3.times.map do |i|
    user = User.create!(
      email:                 "dicente#{i}@gmail.com",
      matricula:             "19008400#{i}",
      password:              'senha',
      password_confirmation: 'senha',
      role:                  'discente'
    )
    user.classes << @class
    user
  end
  
  # Simula respostas
  FormResponse.create!(form: @form, user: @dicentes[0], answers: { 'q1' => 'Excelente' })
  FormResponse.create!(form: @form, user: @dicentes[1], answers: { 'q1' => 'Excelente' })
  FormResponse.create!(form: @form, user: @dicentes[2], answers: { 'q1' => 'Bom' })
  
  visit admin_results_path
  click_button 'Ver Detalhes'
end

Quando('visualizo a questão {string}') do |questao|
  expect(page).to have_content(questao)
end

Então('vejo um gráfico com as opções e seus respectivos percentuais') do
  expect(page).to have_selector('canvas, svg')
  expect(page).to have_content('%')
end

Então('a barra com maior percentual é destacada com uma cor diferente') do
  expect(page).to have_selector('[fill], [style*="color"]')
end

Dado('que abri os detalhes de um formulário com questões do tipo Texto') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação com Comentários',
    start_date: 1.day.ago,
    end_date: 1.day.from_now,
    questions: [
      { type: 'text', text: 'Deixe seu comentário sobre o professor' }
    ]
  )
  @form.classes << @class
  
  @dicentes = 2.times.map do |i|
    user = User.create!(
      email:                 "dicente_txt#{i}@gmail.com",
      matricula:             "19008401#{i}",
      password:              'senha',
      password_confirmation: 'senha',
      role:                  'discente'
    )
    user.classes << @class
    user
  end
  
  # Simula respostas de texto
  FormResponse.create!(form: @form, user: @dicentes[0], answers: { 'q1' => 'Professor excelente!' })
  FormResponse.create!(form: @form, user: @dicentes[1], answers: { 'q1' => 'Muito bom mesmo' })
  
  visit admin_results_path
  click_button 'Ver Detalhes'
end

Então('vejo uma lista com todas as respostas recebidas') do
  expect(page).to have_selector('ul, li')
end

Então('cada resposta exibe o nome do respondente e a data de envio') do
  expect(page).to have_content('dicente_txt')
  expect(page).to have_content(Date.today.strftime('%d/%m/%Y'))
end

Dado('que existem formulários de múltiplas turmas') do
  @class1 = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  @class2 = Class.create!(
    code:     'CIC0202',
    name:     'Banco de Dados',
    semester: '2026.1'
  )
  
  @form1 = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação 1',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form1.classes << @class1
  
  @form2 = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação 2',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form2.classes << @class2
end

Quando('seleciono a turma {string} no filtro') do |turma|
  select turma, from: 'filtro_turma'
end

Então('a tabela exibe apenas os formulários da turma {string}') do |turma|
  expect(page).to have_content(turma)
end

Então('a quantidade de linhas é reduzida') do
  expect(all('table tbody tr').count).to eq(1)
end

Dado('que existem formulários para dicentes e docentes') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @form_dicente = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação para Dicentes',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form_dicente.classes << @class
  
  @form_docente = Form.create!(
    destiny_type: 'docente',
    template_name: 'Avaliação para Docentes',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form_docente.classes << @class
end

Quando('seleciono {string} no filtro {string}') do |opcao, filtro|
  select opcao, from: filtro
end

Então('a tabela exibe apenas os formulários destinados a dicentes') do
  expect(page).to have_content('Dicentes')
end

Então('os formulários para docentes deixam de aparecer') do
  expect(page).not_to have_content('Docentes')
end

Dado('que existem formulários de períodos diferentes') do
  @form1 = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação Maio',
    start_date: '2026-05-01',
    end_date: '2026-05-31'
  )
  
  @form2 = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação Junho',
    start_date: '2026-06-01',
    end_date: '2026-06-30'
  )
end

Quando('seleciono a data de início {string} no filtro {string}') do |data, filtro|
  fill_in filtro, with: data
end

Quando('seleciono a data de término {string} no filtro {string}') do |data, filtro|
  fill_in filtro, with: data
end

Então('a tabela exibe apenas os formulários dentro do período selecionado') do
  expect(page).to have_content('Maio')
end

Dado('que abri os detalhes de um formulário') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação para Exportar',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form.classes << @class
  
  visit admin_results_path
  click_button 'Ver Detalhes'
end

# Removed duplicate click step

Então('um arquivo com as respostas do formulário é baixado') do
  expect(page.response_headers['Content-Disposition']).to include('attachment')
end

Então('o arquivo contém todas as questões e respostas em formato CSV') do
  expect(page.response_headers['Content-Type']).to include('text/csv')
end

Então('um arquivo com as respostas do formulário é baixado em formato PDF') do
  expect(page.response_headers['Content-Disposition']).to include('attachment')
end

Então('o PDF contém um relatório formatado com gráficos e respostas de texto') do
  expect(page.response_headers['Content-Type']).to include('application/pdf')
end

Dado('que existe um formulário criado recentemente sem respostas') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação Sem Respostas',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form.classes << @class
end

Quando('clico em {string} do formulário') do |acao|
  click_button acao
end

Então('o modal exibe a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('não vejo questões nem gráficos') do
  expect(page).not_to have_selector('.questao, canvas, svg')
end

Então('vejo o botão {string}') do |botao|
  expect(page).to have_button(botao)
end

Dado('que existem múltiplos formulários com quantidades diferentes de respostas') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @form1 = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação 1',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form1.classes << @class
  
  @form2 = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação 2',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form2.classes << @class
  
  @dicente1 = User.create!(email: 'dic1@gmail.com', matricula: '190084020', password: 'senha', password_confirmation: 'senha', role: 'discente')
  @dicente2 = User.create!(email: 'dic2@gmail.com', matricula: '190084021', password: 'senha', password_confirmation: 'senha', role: 'discente')
  @dicente3 = User.create!(email: 'dic3@gmail.com', matricula: '190084022', password: 'senha', password_confirmation: 'senha', role: 'discente')
  
  FormResponse.create!(form: @form1, user: @dicente1)
  FormResponse.create!(form: @form1, user: @dicente2)
  FormResponse.create!(form: @form1, user: @dicente3)
  
  FormResponse.create!(form: @form2, user: @dicente1)
end

Quando('clico no cabeçalho da coluna {string}') do |coluna|
  find("th", text: coluna).click
end

Então('a tabela é ordenada em ordem decrescente de respostas') do
  rows = all('table tbody tr')
  expect(rows.first).to have_content('3') # Maior quantidade
end

Quando('clico novamente no cabeçalho') do
  find("th", text: "Respostas Recebidas").click
end

Então('a tabela é ordenada em ordem crescente') do
  rows = all('table tbody tr')
  expect(rows.first).to have_content('1') # Menor quantidade
end

# ==================== CENÁRIOS TRISTES ====================

Dado('que estou logado como Dicente') do
  @dicente = User.create!(
    email:                 'dicente@gmail.com',
    matricula:             '190084015',
    password:              'senha',
    password_confirmation: 'senha',
    role:                  'discente'
  )
  
  visit login_path
  fill_in 'email', with: 'dicente@gmail.com'
  fill_in 'password', with: 'senha'
  click_button 'Entrar'
end

Quando('tento acessar a página {string}') do |pagina|
  visit admin_results_path
end

Então('sou redirecionado para o painel do usuário') do
  expect(page).to have_current_path(home_path, wait: 10)
end

Então('vejo a mensagem de erro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Dado('que nenhum formulário foi criado ou enviado') do
  # Nenhum formulário é criado
end

Então('a tabela está vazia') do
  expect(page).not_to have_selector('table tbody tr')
end

Então('vejo a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('o botão {string} não está disponível') do |botao|
  expect(page).not_to have_button(botao)
end

Dado('que sou um Docente') do
  @docente = User.create!(
    email:                 'docente@gmail.com',
    matricula:             '190084016',
    password:              'senha',
    password_confirmation: 'senha',
    role:                  'docente'
  )
  
  visit login_path
  fill_in 'email', with: 'docente@gmail.com'
  fill_in 'password', with: 'senha'
  click_button 'Entrar'
end

Quando('abro os detalhes de um formulário respondido por seus alunos') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form.classes << @class
  
  @dicente = User.create!(email: 'dic@gmail.com', matricula: '190084017', password: 'senha', password_confirmation: 'senha', role: 'discente')
  FormResponse.create!(form: @form, user: @dicente)
  
  visit admin_form_details_path(@form)
end

Então('não vejo os botões {string} ou {string}') do |botao1, botao2|
  expect(page).not_to have_button(botao1)
  expect(page).not_to have_button(botao2)
end

Então('vejo a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Dado('que um formulário foi deletado do sistema') do
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação Deletada',
    start_date: 1.day.ago,
    end_date: 1.day.from_now
  )
  @form_id = @form.id
  @form.destroy
end

Quando('tento acessar os detalhes deste formulário através de um link antigo') do
  visit admin_form_details_path(@form_id)
end

Então('vejo a mensagem de erro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('sou redirecionado para a página {string}') do |pagina|
  case pagina
  when 'Gerenciamento - Resultados'
    expect(page).to have_current_path(admin_results_path, wait: 10)
  end
end

# Removed duplicate click step

Então('a tabela permanece sem aplicar o filtro') do
  expect(page).to have_selector('table')
end

Então('vejo a mensagem de erro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Dado('que existe um formulário com mais de 1000 respostas') do
  @class = Class.create!(
    code:     'CIC0105',
    name:     'Engenharia de Software',
    semester: '2026.1'
  )
  
  @form = Form.create!(
    destiny_type: 'discente',
    template_name: 'Avaliação com Muitas Respostas',
    start_date: 30.days.ago,
    end_date: 1.day.from_now
  )
  @form.classes << @class
  
  1001.times do |i|
    user = User.find_or_create_by!(email: "dicente_#{i}@gmail.com") do |u|
      u.matricula = "1900840#{format('%02d', i % 100)}"
      u.password = 'senha'
      u.password_confirmation = 'senha'
      u.role = 'discente'
    end
    FormResponse.create!(form: @form, user: user)
  end
end

Quando('abro os detalhes deste formulário') do
  visit admin_results_path
  click_button 'Ver Detalhes'
end

Então('o gráfico não é exibido') do
  expect(page).not_to have_selector('canvas, svg')
end

Então('vejo a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Quando('clico no botão {string} e a exportação falha') do |botao|
  allow(FormResponse).to receive(:for_export).and_raise(StandardError)
  click_button botao
end

Então('vejo a mensagem de erro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('o arquivo não é baixado') do
  expect(page.response_headers['Content-Disposition']).to be_nil
end
