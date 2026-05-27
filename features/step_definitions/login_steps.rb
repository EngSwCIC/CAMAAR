Dado('que meu usuário está cadastrado com o email {string}') do |email|
  # Implementar quando definir models 
end

Dado('que meu email {string} não está cadastrado no sistema') do |email|
  # Implementar quando definir models
end

Dado('que meu usuário está cadastrado com o email {string} e senha {string}') do |email, senha|
  # Implementar quando definir models
end

Dado('que minha matrícula {string} está cadastrada no sistema e senha {string}') do |matricula, senha|
  # Implementar quando definir models
end

Dado('que minha senha para {string} não está definida') do |email|
  # Implementar quando definir models
end

Quando('eu tento realizar o login com o email {string} e a senha {string}') do |email_usuario, senha_usuario|
  fill_in "login", with: email_usuario
  fill_in "senha", with: senha_usuario
  click_button "Entrar"
end

Quando('eu tento realizar o login com matrícula {string} e a senha {string}') do |matricula_usuario, senha_usuario|
  fill_in "login", with: matricula_usuario
  fill_in "senha", with: senha_usuario
  click_button "Entrar"
end

Quando('eu tento realizar o login sem informar meu email ou matrícula e com senha {string}') do |senha_usuario|
  fill_in "senha", with: senha_usuario
  click_button "Entrar"
end

Quando('eu tento realizar o login com email {string} sem informar minha senha') do |email_usuario|
  fill_in "login", with: email_usuario
  click_button "Entrar"
end

Então('vejo a mensagem {string}') do |string|
  expect(page).to have_content(string)
end

Então('permaneço na página de login') do
  expect(page).to have_current_path(root_path)
end

Então('sou direcionado para a página inicial') do
  # expect(page).to have_current_path(avaliacoes_path)
  # implementar quando o nome da rota for determinado
end