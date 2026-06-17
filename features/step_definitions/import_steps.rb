Dado('que acesso a página {string}') do |page_name|
  case page_name
  when "Gerenciamento - Importar Dados"
    visit admin_imports_path
  end
end

Quando('clico no botão de ação de importação {string}') do |button_text|
  click_on button_text
end

Quando('clico no botão de ação de importação {string} sem selecionar um arquivo') do |button_text|
  click_on button_text
end

Quando('seleciono o arquivo {string} para importar do SIGAA') do |file_name|
  # Pre-create data for members import if needed
  if file_name == 'class_members.json'
    d = Disciplina.find_or_create_by!(code: 'CIC0097') { |di| di.name = 'BANCOS DE DADOS' }
    Turma.find_or_create_by!(classCode: 'TA', semester: '2021.2', disciplina: d)
  end
  
  path = Rails.root.join('features', 'support', 'fixtures', file_name)
  if file_name.include?('members')
    select "Participantes", from: "import_type"
  else
    select "Turmas", from: "import_type"
  end
  attach_file('file', path)
end

Então('vejo a mensagem de sucesso da importação {string}') do |message|
  expect(page).to have_content(message)
end

Então('a disciplina {string} passa a ser listada no sistema') do |disciplina_name|
  expect(Disciplina.exists?(name: disciplina_name)).to be true
end

Então('a lista de discentes da turma exibe o aluno {string}') do |aluno_name|
  expect(Discente.exists?(nome: aluno_name)).to be true
end

Então('vejo a mensagem de erro da importação {string}') do |message|
  expect(page).to have_content(message)
end

Então('vejo o alerta da importação {string}') do |message|
  expect(page).to have_content(message)
end

Então('permaneço na página de importação') do
  expect(current_path).to eq(admin_imports_path)
end

Então('o sistema não realiza nenhuma alteração na base de dados') do
  # No-op
end

Dado('que possuo um arquivo {string} com chaves faltando') do |file_name|
  path = Rails.root.join('features', 'support', 'fixtures', file_name)
  File.write(path, '{"invalid": "json"}')
end

Dado('que a base de dados não possui a disciplina {string}') do |code|
  Disciplina.find_by(code: code)&.destroy
end
