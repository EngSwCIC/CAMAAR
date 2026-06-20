MENSAGEM_CREDENCIAIS_INVALIDAS = "Email ou senha inválidos."

# Background

Given('que o usuário está na tela de login') do
  visit login_path
end

# Passos de preenchimento de campos

When('ele informa um email cadastrado') do
  @senha_usuario = 'Senha123'
  @usuario = Usuario.create!(
    nome: 'Usuário Teste',
    email: 'teste@unb.br',
    password: @senha_usuario,
    password_confirmation: @senha_usuario,
    role: :estudante
  )
  fill_in 'Email', with: @usuario.email
end

When('informa a senha correta') do
  fill_in 'Senha', with: @senha_usuario
end

When('ele informa um email que não está cadastrado no sistema') do
  fill_in 'Email', with: 'nao.existe@unb.br'
end

When('informa uma senha qualquer') do
  fill_in 'Senha', with: 'senhaqualquer'
end

When('ele informa o email {string}') do |email|
  fill_in 'Email', with: email
end

When('ele deixa o campo email em brnaco') do
  fill_in 'Email', with: ''
end

When('deixa o campo senha em brnaco') do
  fill_in 'Senha', with: ''
end

When('clica em "entrar"') do
  find('input[type="submit"]').click
end

# Passos de verificação — sucesso

Then('o sistema deve autenticar o usuário') do
  expect(current_path).not_to eq(login_path)
end

Then('deve redirecionar para a tela inicial do sistema') do
  expect([gerenciamento_path, relatorios_path, avaliacoes_path]).to include(current_path)
end

# Passos de verificação — falha

Then('o sistema não deve autenticar o usuário') do
  expect(current_path).to eq(login_path)
end

Then('deve exibir uma mensagem de erro informando que as credenciais são inválidas') do
  expect(page).to have_content(MENSAGEM_CREDENCIAIS_INVALIDAS)
end

Then('deve exibir uma mensagem de erro informando que o email é inválido') do
  expect(page).to have_content('inválido')
end

Then('deve exibir uma mensagem de erro indicando que o email é obrigatório') do
  expect(page).to have_content(MENSAGEM_CREDENCIAIS_INVALIDAS)
end

Then('deve exibir uma mensagem de erro indicando que a senha é obrigatória') do
  expect(page).to have_content(MENSAGEM_CREDENCIAIS_INVALIDAS)
end
