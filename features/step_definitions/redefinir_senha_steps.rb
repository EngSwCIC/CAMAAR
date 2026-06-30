NOVA_SENHA_REDEFINIR = 'Abc12345'
SENHA_ATUAL_REDEFINIR = 'Senha123'

Given('que o usuário está na tela de redefinição de senha') do
  @usuario = Usuario.create!(
    nome: 'Usuário Redefinição',
    email: 'redef@unb.br',
    password: SENHA_ATUAL_REDEFINIR,
    password_confirmation: SENHA_ATUAL_REDEFINIR,
    role: :estudante
  )
  @token = @usuario.generate_token_for(:password_reset)
  visit senha_nova_path(token: @token)
end

Given('que o link de redefinição utilizado pelo usuário já expirou') do
  # Changing password_digest invalidates the JWT token (digest is embedded in the token)
  @usuario.update_column(:password_digest, BCrypt::Password.create('OutraSenha456!'))
end

When('ele coloca a nova senha no primeiro campo') do
  @nova_senha = NOVA_SENHA_REDEFINIR
  fill_in 'password', with: @nova_senha
end

When('ele coloca a mesma nova senha no segundo campo') do
  fill_in 'password_confirmation', with: @nova_senha
end

When('ele coloca uma nova senha diferente no segundo campo') do
  fill_in 'password_confirmation', with: 'Xyz99999!'
end

When('ele coloca uma senha que não atende aos requisitos mínimos no primeiro campo') do
  @nova_senha = 'abc'
  fill_in 'password', with: @nova_senha
end

When('ele coloca a mesma senha no segundo campo') do
  fill_in 'password_confirmation', with: @nova_senha
end

When('ele coloca a senha atual no primeiro campo') do
  @nova_senha = SENHA_ATUAL_REDEFINIR
  fill_in 'password', with: @nova_senha
end

When('ele deixa o primeiro campo em branco') do
  fill_in 'password', with: ''
end

When('ele deixa o segundo campo em branco') do
  fill_in 'password_confirmation', with: ''
end

When('ele coloca uma nova senha no primeiro campo') do
  @nova_senha = NOVA_SENHA_REDEFINIR
  fill_in 'password', with: @nova_senha
end

When('ele clica em "mudar de senha"') do
  @digest_antes_do_clique = @usuario.reload.password_digest
  find('input[type="submit"]').click
end

Then('o sistema deve mudar a senha de acesso desse usuário') do
  expect(@usuario.reload.authenticate(NOVA_SENHA_REDEFINIR)).to be_truthy
end

Then('o sistema deve exibir uma mensagem de erro informando que as duas senhas não batem') do
  expect(page).to have_css('.auth-alert')
  expect(page).to have_content('não são iguais')
end

Then('o sistema não deve alterar a senha do usuário') do
  expect(@usuario.reload.password_digest).to eq(@digest_antes_do_clique)
end

Then('deve exibir uma mensagem de erro informando os requisitos mínimos de senha') do
  expect(page).to have_content('8 caracteres')
end

Then('deve exibir uma mensagem de erro informando que a nova senha deve ser diferente da atual') do
  expect(page).to have_content('diferente da senha atual')
end

Then('deve exibir uma mensagem de erro indicando que a nova senha é obrigatória') do
  expect(page).to have_content('obrigatória')
end

Then('deve exibir uma mensagem informando que o link expirou') do
  expect(page).to have_css('.auth-alert')
  expect(page).to have_content('expirado')
end

Then('deve oferecer a opção de solicitar um novo link') do
  expect(current_path).to eq(recuperar_senha_path)
  expect(page).to have_button('Enviar instruções')
end
