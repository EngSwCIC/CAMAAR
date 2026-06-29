require "cgi"

SENHA_VALIDA = "novaSenha123".freeze

Dado("que recebo um e-mail com um link de definição de senha válido") do
  @user = User.create!(
    nome: "Usuario Sem Senha",
    email: "novo_usuario@camaar.com",
    matricula: "202400099",
    perfil: "Discente",
    primeiro_acesso: true
  )
  @definir_senha_url = "/definir_senha?email=#{CGI.escape(@user.email)}"
end

Dado("que recebo um e-mail com um link de definição de senha inválido ou expirado") do
  @definir_senha_url = "/definir_senha?email=inexistente@camaar.com"
end

Quando("eu acesso o link e preencho o campo {string} com uma senha válida") do |campo|
  visit @definir_senha_url
  fill_in campo, with: SENHA_VALIDA
end

Quando("preencho o campo {string} com a mesma senha informada no campo {string}") do |campo_conf, _campo_nova|
  fill_in campo_conf, with: SENHA_VALIDA
end

Quando("eu acesso o link e não preencho os campos de senha") do
  visit @definir_senha_url
end

Quando("eu acesso o link e preencho com senhas que não correspondem") do
  visit @definir_senha_url
  fill_in "Nova Senha", with: "senhaA123"
  fill_in "Confirmar Senha", with: "senhaB456"
end

Quando("eu tento acessar o link para definir minha senha") do
  visit @definir_senha_url
end

Quando("clico em {string}") do |botao|
  click_button botao
end

Então("a senha deve ser definida com sucesso") do
  user = @user.reload
  expect(user.authenticate(SENHA_VALIDA)).to be_truthy
  expect(user.primeiro_acesso).to be(false)
end

Então("eu devo conseguir acessar o sistema utilizando a nova senha") do
  visit login_path
  fill_in "E-mail ou matrícula", with: @user.email
  fill_in "Senha", with: SENHA_VALIDA
  click_button "Entrar"
  expect(page).to have_content("Perfil de Discente")
end

Então(/devo ver (?:uma|a) mensagem "([^"]*)"/) do |mensagem|
  expect(page).to have_content(mensagem)
end

Então("eu não devo conseguir definir minha senha") do
  expect(page).to have_content("Link de definição de senha inválido ou expirado")
end

Então("eu não devo conseguir acessar o sistema") do
  expect(@user.reload.primeiro_acesso).to be(true)
end
