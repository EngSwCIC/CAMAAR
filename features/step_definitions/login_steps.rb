Dado('que meu usuário está cadastrado com o email {string}') do |email|
  Usuario.find_or_create_by!(email: email) do |u|
    u.matricula = "#{rand(100000..999999)}"
    u.nome = "Usuário Teste"
  end
end

Dado('que meu email {string} não está cadastrado no sistema') do |email|
  Usuario.where(email: email).delete_all
end

Dado('que meu usuário está cadastrado com o email {string} e senha {string}') do |email, senha|
  usuario = Usuario.find_or_initialize_by(email: email)
  usuario.matricula ||= "#{rand(100000..999999)}"
  usuario.nome ||= "Usuário Teste"
  usuario.senha = senha
  usuario.senha_confirmation = senha
  usuario.save!
end

Dado('que minha matrícula {string} está cadastrada no sistema e senha {string}') do |matricula, senha|
  usuario = Usuario.find_or_initialize_by(matricula: matricula)
  usuario.email ||= "#{matricula}@teste.com"
  usuario.nome ||= "Usuário Teste"
  usuario.senha = senha
  usuario.senha_confirmation = senha
  usuario.save!
end

Dado('que minha senha para {string} não está definida') do |email|
  usuario = Usuario.find_by!(email: email)
  usuario.update!(senha_hash: nil)
end

Quando('eu tento realizar o login com o email {string} e a senha {string}') do |email_usuario, senha_usuario|
  visit root_path
  fill_in "login", with: email_usuario
  fill_in "senha", with: senha_usuario
  click_button "Entrar"
end

Quando('eu tento realizar o login com matrícula {string} e a senha {string}') do |matricula_usuario, senha_usuario|
  visit root_path
  fill_in "login", with: matricula_usuario
  fill_in "senha", with: senha_usuario
  click_button "Entrar"
end

Quando('eu tento realizar o login sem informar meu email ou matrícula e com senha {string}') do |senha_usuario|
  visit root_path
  fill_in "senha", with: senha_usuario
  click_button "Entrar"
end

Quando('eu tento realizar o login com email {string} sem informar minha senha') do |email_usuario|
  visit root_path
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
  expect(page).to have_current_path(inicio_path)
end
