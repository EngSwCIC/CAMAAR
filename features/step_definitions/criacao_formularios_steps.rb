Dado('que o administrador esteja na tela de {string}') do |nome_tela|
  @admin = Pessoa.create!(
    usuario: 'admin_forms',
    password: '123',
    password_confirmation: '123',
    nome: 'Admin',
    admin: true
  )
  
  pessoa_prof = Pessoa.create!(
    usuario: 'prof_algo',
    password: '123',
    password_confirmation: '123',
    nome: 'Prof Algoritmos'
  )
  docente = Docente.create!(pessoa: pessoa_prof)
  
  disciplina = Disciplina.create!(nome: 'Algoritmos', codigo: 'ALG001')
  @turma = Turma.create!(codigo: '2', disciplina: disciplina, docente: docente)
  
  @template = Template.create!(nome: 'Template Avaliação', pessoa: @admin)

  visit login_path
  fill_in 'login', with: @admin.usuario
  fill_in 'password', with: '123'
  click_button 'Entrar'
  
  visit new_admin_formulario_path
end

Quando('selecionar a matéria {string} e a turma {string}') do |materia, turma_codigo|
  check "turma_ids_#{@turma.id}"
end

Quando('definir o público-alvo como {string}') do |publico|
end

Quando('preencher ao menos uma pergunta no formulário') do
  TemplateQuestao.create!(
    template: @template,
    enunciado: "Pergunta teste BDD?",
    tipo_resposta: "texto"
  )
  select @template.nome, from: 'template_id'
end

Quando('não adicionar nenhuma pergunta ao formulário') do
  @template.template_questoes.destroy_all
  select @template.nome, from: 'template_id' 
end

Quando('acionar o botão {string}') do |botao|
  click_button botao
end

Então('o sistema deve registrar o formulário com sucesso') do
  expect(Formulario.where(turma: @turma, template: @template)).to exist
end

Então('exibir a mensagem de confirmação {string}') do |mensagem|
  expect(page).to have_content("com sucesso")
end

Então('o formulário deve estar disponível para os professores da turma {string}') do |codigo_turma|
  formulario = Formulario.last
  expect(formulario.turma.codigo).to eq(codigo_turma)
end

Então('o sistema deve impedir a publicação do formulário') do
  expect(Formulario.count).to eq(0)
end

Então('apresentar a mensagem de erro {string}') do |mensagem|
  expect(page.body.downcase).to include("ao menos uma pergunta")
end