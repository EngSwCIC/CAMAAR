# encoding: utf-8

# ==================== CONTEXTO ====================

# Dado('que estou logado como Administrador')
# Dado('estou na página {string}')
# Dado('clico no botão {string}')

Dado('que a turma {string} possui respostas registradas') do |nome_turma|
  # Cria disciplina, turma, docente e respostas associadas
  @disciplina = Disciplina.create!(
    code: 'CIC0001',
    name: 'Engenharia de Software'
  )

  @docente = User.create!(
    email:                 'prof.fulano@unb.br',
    matricula:             '111000001',
    password:              'senhaDocente',
    password_confirmation: 'senhaDocente',
    role:                  'docente',
    nome:                  'Prof. Fulano',
    departamento:          'CIC'
  )

  @turma = Turma.create!(
    classCode:    'T01',
    semester:     '2024.1',
    time:         '10:00',
    disciplina:   @disciplina
  )
  @turma.docentes << @docente

  @template = Template.create!(name: 'Avaliação Padrão')
  @questao1  = @template.questions.create!(
    kind: 'radio',
    text: 'Como você avalia a didática?',
    options: ['Muito bom', 'Bom', 'Regular', 'Ruim']
  )
  @questao2  = @template.questions.create!(kind: 'text',  text: 'Comentários adicionais')

  @form = Form.create!(
    template:     @template,
    start_date:   1.day.ago,
    end_date:     1.day.from_now
  )
  @form.turmas << @turma

  @discente = User.create!(
    email:                 'discente@gmail.com',
    matricula:             '190084010',
    password:              'senhaDicente',
    password_confirmation: 'senhaDicente',
    role:                  'discente',
    nome:                  'Discente Teste'
  )
  @discente.turmas << @turma

  FormResponse.create!(
    form:      @form,
    user:      @discente,
    turma:     @turma,
    answers:   [
      { question_id: @questao1.id, value: 'Muito bom' },
      { question_id: @questao2.id, value: 'Ótimo monitor' }
    ]
  )
end

Dado('que a turma {string} possui respostas de questões do tipo Radio e Texto') do |nome_turma|
  # Reaproveita o setup acima — turma já tem questões dos dois tipos
  step "que a turma \"#{nome_turma}\" possui respostas registradas"
end

Dado('que a turma {string} não possui nenhuma resposta registrada') do |nome_turma|
  @disciplina = Disciplina.create!(
    code: 'FGA0002',
    name: 'Software Básico'
  )
  @docente = User.create!(
    email:                 'prof.ciclano@unb.br',
    matricula:             '111000002',
    password:              'senhaDocente2',
    password_confirmation: 'senhaDocente2',
    role:                  'docente',
    nome:                  'Prof. Ladeira'
  )
  @turma_sem_respostas = Turma.create!(
    classCode:  'T02',
    semester:   '2024.1',
    time:       '14:00',
    disciplina: @disciplina
  )
  @turma_sem_respostas.docentes << @docente

  @template = Template.create!(name: 'Avaliação Vazia')
  @form_vazio = Form.create!(
    template:   @template,
    start_date: 1.day.ago,
    end_date:   1.day.from_now
  )
  @form_vazio.turmas << @turma_sem_respostas
  # Nenhuma FormResponse criada
end

Dado('que nenhum formulário foi enviado para nenhuma turma') do
  # Garante que o banco está limpo de formulários
  Form.destroy_all
  Turma.destroy_all
end

# ==================== AÇÕES ====================

Quando('clico no card da turma {string}') do |nome_turma|
  visit admin_results_path
  within('.turma-card', text: nome_turma.split(' - ').first) do
    click_on nome_turma.split(' - ').first
  end
end

Quando('acesso {string}') do |pagina|
  case pagina
  when 'Gerenciamento - Resultados'
    visit admin_results_path
  end
end


# ==================== VERIFICAÇÕES - CENÁRIOS FELIZES ====================

Então('vejo uma listagem de cards com turmas') do
  expect(page).to have_selector('.turma-card')
end

Então('cada card exibe o {string}, o {string} e o {string}') do |campo1, campo2, campo3|
  within('.turma-card', match: :first) do
    expect(page).to have_selector('.turma-nome')
    expect(page).to have_selector('.turma-semestre')
    expect(page).to have_selector('.turma-professor')
  end
end

Então('um arquivo CSV é baixado com os resultados da turma selecionada') do
  # Verifica que a resposta HTTP tem Content-Type de CSV
  expect(page.response_headers['Content-Type']).to include('text/csv')
  expect(page.response_headers['Content-Disposition']).to include('attachment')
  expect(page.response_headers['Content-Disposition']).to include('.csv')
end

Então('o arquivo contém as colunas {string}, {string}, {string} e {string}') do |col1, col2, col3, col4|
  csv_content = page.body
  headers     = CSV.parse(csv_content, headers: true).headers
  expect(headers).to include(col1, col2, col3, col4)
end

Então('cada linha corresponde a uma resposta submetida por um discente') do
  csv_content = page.body
  rows        = CSV.parse(csv_content, headers: true)
  expect(rows.length).to be >= 1
  rows.each do |row|
    expect(row['Discente']).not_to be_blank
    expect(row['Resposta']).not_to be_blank
  end
end

Então('o arquivo CSV baixado contém uma coluna para cada questão do formulário') do
  csv_content     = page.body
  rows            = CSV.parse(csv_content, headers: true)
  questao_textos  = @form.template.questions.pluck(:text)
  textos_presentes = rows.map { |row| row['Questão'] }
  questao_textos.each do |texto|
    expect(textos_presentes).to include(texto)
  end
end

Então('os valores correspondem às respostas selecionadas ou digitadas pelos discentes') do
  csv_content = page.body
  rows        = CSV.parse(csv_content, headers: true)
  expect(rows.length).to be >= 1
  @form.template.questions.each do |questao|
    linhas_da_questao = rows.select { |row| row['Questão'] == questao.text }
    expect(linhas_da_questao).not_to be_empty
    linhas_da_questao.each { |row| expect(row['Resposta']).not_to be_blank }
  end
end

# ==================== VERIFICAÇÕES - CENÁRIOS TRISTES ====================

Então('nenhum arquivo é baixado') do
  expect(page.response_headers['Content-Type']).not_to include('text/csv')
end

Então('vejo a mensagem de aviso {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('nenhum card de turma é exibido') do
  expect(page).not_to have_selector('.turma-card')
end
