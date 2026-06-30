SENHA_VALIDA_DEFINICAO = 'NovaSenha123'
SENHA_FRACA_DEFINICAO  = 'fraca'

# Background

Given('que existe um novo usuário importado do SIGAA sem senha definida') do
  # Simula usuário criado via importação do SIGAA: sem password_digest
  @novo_usuario = Usuario.create!(
    nome: 'Novo Usuário SIGAA',
    email: 'novo.sigaa@unb.br',
    role: :estudante
  )
end

# Given

Given('que o usuário acessa o link de convite recebido por email') do
  token = @novo_usuario.generate_token_for(:password_reset)
  visit senha_nova_path(token: token)
end

Given('que o usuário possui um link de convite inválido ou expirado') do
  @token_invalido = 'link_invalido_expirado_xxx'
end

# When

When('preenche a nova senha no campo senha') do
  @senha_definida = SENHA_VALIDA_DEFINICAO
  fill_in 'password', with: @senha_definida
end

When('preenche a mesma senha no campo de confirmação') do
  fill_in 'password_confirmation', with: @senha_definida
end

When('preenche uma senha que não atende aos requisitos no campo senha') do
  @senha_definida = SENHA_FRACA_DEFINICAO
  fill_in 'password', with: @senha_definida
end

When('preenche uma senha diferente no campo de confirmação') do
  fill_in 'password_confirmation', with: 'DiferenteSenha456'
end

When('deixa o campo senha em branco') do
  fill_in 'password', with: ''
end

When('deixa o campo de confirmação em branco') do
  fill_in 'password_confirmation', with: ''
end

When('tenta acessar a página de definição de senha') do
  visit senha_nova_path(token: @token_invalido)
end

When('clica em "Redefinir senha"') do
  @digest_antes = @novo_usuario.reload.password_digest
  find('input[type="submit"]').click
end

# Then — Scenario 1: sucesso

Then('o sistema deve salvar a senha do usuário') do
  expect(@novo_usuario.reload.authenticate(SENHA_VALIDA_DEFINICAO)).to be_truthy
end

Then('o usuário deve conseguir realizar login com a senha definida') do
  visit login_path
  fill_in 'Email', with: @novo_usuario.email
  fill_in 'Senha', with: SENHA_VALIDA_DEFINICAO
  find('input[type="submit"]').click
  expect(current_path).not_to eq(login_path)
end

# Then — Scenarios 2, 3, 4: falha

Then('o sistema não deve salvar a senha do usuário') do
  expect(@novo_usuario.reload.password_digest).to eq(@digest_antes)
end

# 'deve exibir uma mensagem de erro informando os requisitos mínimos de senha'
# só q já foi definido em redefinir_senha_steps.rb

Then('deve exibir uma mensagem de erro informando que as senhas não coincidem') do
  expect(page).to have_css('.auth-alert')
  expect(page).to have_content('não são iguais')
end

# 'deve exibir uma mensagem de erro indicando que a nova senha é obrigatória'
# só q já foi definido em redefinir_senha_steps.rb

# Then — Scenario 5: link inválido

Then('o sistema deve redirecionar para a página de recuperação de senha') do
  expect(current_path).to eq(recuperar_senha_path)
end

Then('deve exibir uma mensagem informando que o link é inválido ou expirou') do
  expect(page).to have_content('expirado')
end
