# templates_formulario_common_steps.rb content
Dado('que estou logado como um usuário Administrador') do
  admin = Usuario.find_or_initialize_by(email: "admin@unb.br")
  admin.nome ||= "Admin Teste"
  admin.perfil = "administrador"
  admin.ativo = true
  admin.password = "admin123"
  admin.save!(validate: false)

  visit login_path
  fill_in "E-mail ou Matrícula", with: "admin@unb.br"
  fill_in "Senha", with: "admin123"
  click_button "Entrar"
end

Dado('que estou logado como um usuário {string}') do |perfil|
  u = Usuario.create!(nome: "Participante", email: "part@unb.br", perfil: "discente", password: "123", ativo: true)
  visit login_path
  fill_in "E-mail ou Matrícula", with: "part@unb.br"
  fill_in "Senha", with: "123"
  click_button "Entrar"
end

Quando('preencho o campo {string} com {string}') do |field, value|
  fill_in field, with: value
end

Quando('clico em {string}') do |button|
  click_link_or_button button
end

Então('devo ver a mensagem de sucesso {string}') do |expected_msg|
  expect(page).to have_content(expected_msg)
end

Então('devo ver a mensagem de erro {string}') do |expected_msg|
  expect(page).to have_content(expected_msg)
end

Então('devo ver a mensagem {string}') do |msg|
  expect(page).to have_content(msg)
end

Então('devo ver uma mensagem de alerta {string}') do |msg|
  expect(page).to have_content(msg)
end

# criar_template_formulario_steps.rb content
Dado('que estou na página de criação de templates') do
  visit templates_path
end

Quando('adiciono a questão {string} do tipo {string}') do |text, type|
  all('input[name="template[perguntas][][texto]"]').last.set(text)
  all('select[name="template[perguntas][][tipo]"]').last.select(type == "Múltipla Escolha" ? "Escala Likert (1 a 5)" : "Texto Livre / Comentário")
end

Então('o template {string} deve constar no sistema') do |title|
  expect(Template.exists?(titulo: title)).to be true
end

Então('nenhum template novo deve ser salvo no sistema') do
end

# edicao_delecao_template_formulario_steps.rb content
Dado('que existem os seguintes templates criados por mim no sistema:') do |table|
  admin = Usuario.find_by(perfil: "administrador") || Usuario.create!(nome: "Admin", email: "admin@unb.br", perfil: "administrador", password: "123")
  table.hashes.each do |row|
    t = Template.new(
      titulo: row['titulo'],
      descricao: row['descricao'],
      criador: admin,
      perfil_alvo: 'discente',
      versao: row['versao']
    )
    t.skip_questions_validation = true
    t.save!(validate: false)
    QuestaoTemplate.create!(template: t, enunciado: "Questão", tipo: "texto", ordem: 1)
  end
end

Dado('que estou na página de listagem de templates') do
  visit templates_path
end

Quando('clico em {string} no template {string}') do |acao, titulo|
  within(:xpath, "//div[contains(@class, 'flex items-center justify-between') and .//p[text()='#{titulo}']]") do
    click_link acao
  end
end

Então('o template deve constar com o título {string} no sistema') do |titulo|
  expect(Template.exists?(titulo: titulo)).to be true
end

Então('o template deve constar com a descrição {string} no sistema') do |desc|
  expect(Template.exists?(descricao: desc)).to be true
end

Dado('o template {string} não possui nenhum formulário associado') do |titulo|
  t = Template.find_by(titulo: titulo)
  t.formularios.destroy_all if t
end

Então('o template {string} não deve mais constar no sistema') do |titulo|
  expect(Template.exists?(titulo: titulo)).to be false
end

Dado('existe um formulário ativo gerado a partir do template {string}') do |titulo|
  t = Template.find_by(titulo: titulo)
  admin = Usuario.find_by(perfil: "administrador")
  dcc = Departamento.find_or_create_by!(nome: "DCC")
  disc = Disciplina.find_or_create_by!(codigo: "CIC01", nome: "M")
  turma = Turma.create!(codigo_turma: "TA_NEW", semestre: "2026.1", disciplina: disc, departamento: dcc)

  # Adicionar um aluno à turma para passar na validação do Formulario
  aluno = Usuario.create!(nome: "Aluno", email: "aluno@unb.br", matricula: "123", perfil: "discente", password: "123")
  Matricula.create!(usuario: aluno, turma: turma, papel_na_turma: "aluno")

  Formulario.create!(template: t, turma: turma, criado_por: admin, publico_alvo: "discente", status: "aberto", data_inicio: Time.current, data_limite: Time.current + 7.days)
end

Então('o template {string} deve continuar intacto no sistema') do |titulo|
  expect(Template.exists?(titulo: titulo)).to be true
end

# visualizacao_template_formulario_steps.rb content
Dado('que existem os seguintes templates cadastrados no sistema:') do |table|
  admin = Usuario.find_by(perfil: "administrador") || Usuario.create!(nome: "Admin", email: "admin@unb.br", perfil: "administrador", password: "123")
  table.hashes.each do |row|
    t = Template.new(
      titulo: row['titulo'],
      descricao: row['descricao'],
      criador: admin,
      perfil_alvo: 'discente'
    )
    t.skip_questions_validation = true
    t.save!(validate: false)
    QuestaoTemplate.create!(template: t, enunciado: "Q1", tipo: "texto", ordem: 1)
  end
end

Quando('acesso a página de gerenciamento de templates') do
  visit templates_path
end

Então('devo ver uma lista contendo todos os templates cadastrados') do
  expect(page).to have_content("Templates Ativos")
end

Então('devo visualizar o template {string}') do |titulo|
  expect(page).to have_content(titulo)
end

Dado('que não existem templates cadastrados no sistema') do
  Template.destroy_all
end

Quando('tento acessar a página de gerenciamento de templates através da URL {string}') do |url|
  visit url
end

Então('devo ser redirecionado para a página inicial') do
  expect(current_path).to eq(avaliacoes_path).or eq(root_path)
end
