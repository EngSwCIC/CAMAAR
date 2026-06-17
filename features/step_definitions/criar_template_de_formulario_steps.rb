Dado('que estou na página de criar template') do
  @admin = Pessoa.create!(
    usuario: "admin_template_form",
    password: "123",
    password_confirmation: "123",
    nome: "Admin Templates",
    admin: true
  )

  visit login_path
  fill_in 'login', with: @admin.usuario
  fill_in 'password', with: '123'
  click_button 'Entrar'

  visit new_admin_template_path
end

#-----HAPPY PATH ---

Quando("eu preencho o campo 'Nome do template:'") do
  @nome_template = "Avaliação de Disciplina"
  fill_in 'Nome do template:', with: @nome_template
end

Quando("clico no botão '+'") do
  click_button '+'
end

Quando("seleciono o 'Público-alvo:'") do
  select 'Discente', from: 'Público-alvo:'
end

Quando("preencho o campo 'Enunciado da questão:'") do
  fill_in 'Enunciado da questão:', with: "O que você achou da disciplina?"
end

Quando("clico no botão 'Criar'") do
  click_button 'Criar'
end

Então('o novo template deve aparecer na tela de meus templates') do
  visit admin_templates_path
  expect(page).to have_content(@nome_template)
end

#-----SAD PATH ---

Quando("eu deixo o campo 'Nome do template:' vazio") do
  fill_in 'Nome do template:', with: ''
end

Quando('adiciono uma questão válida') do
  fill_in 'Enunciado da questão:', with: "O que você achou da disciplina?"
end

Então("deve aparecer uma mensagem 'O nome do template é obrigatório'") do
  expect(page).to have_content('O nome do template é obrigatório')
end
