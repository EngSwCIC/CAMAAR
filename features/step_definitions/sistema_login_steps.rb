Dado('que a página de login do sistema está disponível para acesso') do
  visit login_path
end

Dado('que existe um administrador registrado com o e-mail {string} e senha {string}') do |email, senha|
  Pessoa.create!(
    email: email, 
    password: senha, 
    password_confirmation: senha, 
    admin: true,
    nome: "Administrador Teste",
    usuario: "admin123" 
  )
end

Quando('o usuário preenche o campo de identificação com {string}') do |identificacao|
  fill_in 'login', with: identificacao 
end

Quando('preenche o campo de senha com {string}') do |senha|
  fill_in 'password', with: senha
end

Quando('aciona o botão {string}') do |nome_botao|
  click_button nome_botao
end

Então('o sistema deve autenticar o usuário com sucesso') do
end

Então('redirecionar para a página inicial do sistema') do
  expect(current_path).to eq(admin_root_path)
end

Então('a opção {string} deve estar visível no menu lateral') do |opcao_menu|
  expect(page).to have_content(opcao_menu)
end

Dado('que o sistema não possui nenhum cadastro com a matrícula {string}') do |matricula|
  Pessoa.find_by(usuario: matricula)&.destroy
end

Então('o sistema deve recusar o acesso') do
  expect(current_path).not_to eq(admin_root_path)
end

Então('exibir a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('o usuário deve permanecer na página de login') do
  expect(page).to have_button('Entrar')
end