Dado('que o administrador esteja autenticado no sistema') do
  @admin = Pessoa.create!(
    usuario: "admin_edicao_template",
    email: "admin_edicao_template@unb.br",
    password: "123",
    password_confirmation: "123",
    nome: "Admin Edicao Templates",
    admin: true
  )

  visit login_path
  fill_in 'login', with: @admin.email
  fill_in 'password', with: '123'
  click_button 'Entrar'
end

Dado('que exista ao menos um template criado por esse administrador') do
  @template = Template.create!(nome: "Template Original", pessoa: @admin)
  TemplateQuestao.create!(template: @template, enunciado: "Pergunta original?", tipo_resposta: "texto")

  pessoa_prof = Pessoa.create!(usuario: "prof_edicao_template", email: "prof_edicao_template@unb.br", password: "123", password_confirmation: "123", nome: "Professor Edicao")
  docente = Docente.create!(pessoa: pessoa_prof)
  disciplina = Disciplina.create!(nome: "Algoritmos", codigo: "CIC0003")
  turma = Turma.create!(codigo: "TA", disciplina: disciplina, docente: docente)

  @formulario = Formulario.create!(turma: turma, template: @template, status: :aberto)
end

Quando('o administrador navega até a lista de templates disponíveis') do
  visit admin_templates_path
end

Quando('seleciona um template para editar') do
  visit edit_admin_template_path(@template)
end

Quando('realiza modificações válidas em seu conteúdo') do
  @novo_nome = "Template Atualizado"
  fill_in 'Nome do template:', with: @novo_nome
end

Quando('salva as alterações realizadas') do
  click_button 'Salvar'
end

Então('o sistema deve atualizar o template com as novas informações') do
  @template.reload
  expect(@template.nome).to eq(@novo_nome)
end

Então('os formulários previamente gerados a partir desse template devem permanecer inalterados') do
  @formulario.reload
  expect(@formulario.template_id).to eq(@template.id)
end

Então('uma mensagem de confirmação deve ser exibida ao administrador') do
  expect(page).to have_content("sucesso")
end

Quando('substitui informações obrigatórias por dados inválidos ou em branco') do
  fill_in 'Nome do template:', with: ''
end

Quando('tenta salvar as alterações') do
  click_button 'Salvar'
end

Então('o sistema deve bloquear o salvamento') do
  @template.reload
  expect(@template.nome).to eq("Template Original")
end

Então('exibir uma mensagem de erro apontando os campos que precisam ser corrigidos') do
  expect(page.body.downcase).to include("erro")
end