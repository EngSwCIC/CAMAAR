Given('que o usuário está na tela de cadastro') do
  visit signup_path
end

When('ele informa nome válido') do
  fill_in 'Nome', with: 'João Silva'
end

When('ele informa um nome válido') do
  fill_in 'Nome', with: 'João Silva'
end

When('informa email válido') do
  fill_in 'Email', with: 'joao@unb.br'
end

When('informa um email válido') do
  fill_in 'Email', with: 'joao@unb.br'
end

When('informa uma senha válida') do
  fill_in 'Senha', with: 'Senha123'
  fill_in 'Confirmação de senha', with: 'Senha123'
end

When('ele informa um email já cadastrado') do
  Usuario.create!(
    nome: 'Usuário Existente',
    email: 'existente@unb.br',
    password: 'Senha123',
    password_confirmation: 'Senha123',
    role: :estudante
  )
  fill_in 'Email', with: 'existente@unb.br'
end

When('informa um email em formato inválido') do
  fill_in 'Email', with: 'email-invalido'
end

When('informa uma senha que não atende aos requisitos mínimos de complexidade') do
  fill_in 'Senha', with: 'abc'
  fill_in 'Confirmação de senha', with: 'abc'
end

When('confirma com uma senha diferente da informada') do
  fill_in 'Confirmação de senha', with: 'Diferente123'
end

When('ele deixa o campo nome em branco') do
  fill_in 'Nome', with: ''
end

Then('o sistema deve cadastrar o usuário com sucesso') do
  find('input[type="submit"]').click
  expect(current_path).to eq(login_path)
  expect(page).to have_content('Usuário cadastrado com sucesso.')
end

Then('o sistema deve exibir uma mensagem de erro informando que o email já existe') do
  find('input[type="submit"]').click
  expect(current_path).to eq(signup_path)
  expect(page).to have_css('[role="alert"]')
  expect(page).to have_content('taken')
end

Then('o sistema não deve cadastrar o usuário') do
  find('input[type="submit"]').click
  expect(current_path).to eq(signup_path)
end

# 'deve exibir uma mensagem de erro informando que o email é inválido'
# is defined in login_usuario_steps.rb and shared between login and signup scenarios

# 'deve exibir uma mensagem de erro informando os requisitos mínimos de senha'
# is defined in redefinir_senha_steps.rb

Then('deve exibir uma mensagem de erro informando que as senhas não conferem') do
  expect(page).to have_css('[role="alert"]')
  expect(page).to have_content("doesn't match")
end

Then('deve exibir uma mensagem de erro indicando que o nome é obrigatório') do
  expect(page).to have_content('é obrigatório')
end
