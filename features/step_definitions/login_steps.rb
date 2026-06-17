# encoding: utf-8

# ==================== CONTEXTO ====================

Dado('que os usuários estão cadastrados no sistema') do
  User.create!(
    email:                 'user@gmail.com',
    matricula:             '190084006',
    password:              'senhaUser',
    password_confirmation: 'senhaUser',
    role:                  'discente'
  )

  User.create!(
    email:                 'admin@gmail.com',
    matricula:             '000000000',
    password:              'senhaAdmin',
    password_confirmation: 'senhaAdmin',
    role:                  'admin'
  )
end

Dado('que estou na página de login do CAMAAR') do
  visit login_path
end

# ==================== AÇÕES ====================

Quando('preencho o campo {string} com {string}') do |campo, valor|
  fill_in campo, with: valor
end

# Removed duplicate click step

# ==================== VERIFICAÇÕES ====================

Então('sou redirecionado para o painel principal') do
  expect(page).to have_current_path(home_path, wait: 10)
end

Então('vejo a mensagem de sucesso {string}') do |mensagem|
expect(page).to have_content(mensagem)
end

Então('vejo a mensagem de erro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('vejo a opção {string} no menu lateral') do |string|
  expect(page).to have_content(string)
end

Então('não vejo a opção {string} no menu lateral') do |string|
  expect(page).not_to have_content(string)
end

Então('permaneço na página de login') do
  expect(page).to have_current_path(login_path)
end