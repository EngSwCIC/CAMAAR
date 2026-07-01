require 'securerandom'

Before do
  User.delete_all
end

Dado('que acesso o formulário de {string}') do |_formulario|
  visit login_path
end

Quando('eu preencho o campo de {string} com um e-mail ou matrícula de um {string} cadastrado') do |campo, perfil|
  senha = '123456'

  @usuario = User.create!(
    nome: "#{perfil} Teste",
    email: "#{perfil.downcase}_#{SecureRandom.hex(4)}@camaar.com",
    matricula: perfil == 'Administrador' ? "000#{SecureRandom.random_number(999999)}" : "2024#{SecureRandom.random_number(999999)}",
    perfil: perfil,
    password: senha,
    password_confirmation: senha
  )

  fill_in campo, with: @usuario.email
end

Quando('preencho o campo {string} com a senha correspondente válida') do |campo|
  fill_in campo, with: '123456'
end

Quando('clico no botão {string}') do |botao|
  click_button botao
end

Então('devo ser redirecionado para a página com perfil de {string}') do |perfil|
  expect(page).to have_content("Perfil de #{perfil}")
end

Então('não devo ver a opção de {string} no menu lateral') do |opcao|
  expect(page).not_to have_content(opcao)
end

Então('devo ver a opção de {string} no menu lateral') do |opcao|
  expect(page).to have_content(opcao)
end

Quando('eu preencho o campo de {string} com um e-mail ou matrícula não cadastrado') do |campo|
  fill_in campo, with: 'naoexiste@camaar.com'
end

Quando('preencho o campo {string} com qualquer senha') do |campo|
  fill_in campo, with: 'qualquer'
end

Quando('eu preencho o campo de {string} com um e-mail ou matrícula cadastrado') do |campo|
  @usuario = User.create!(
    nome: 'Discente Teste',
    email: "discente_senha_errada_#{SecureRandom.hex(4)}@camaar.com",
    matricula: "2024#{SecureRandom.random_number(999999)}",
    perfil: 'Discente',
    password: '123456',
    password_confirmation: '123456'
  )

  fill_in campo, with: @usuario.email
end

Quando('preencho o campo {string} com uma senha não correspondente') do |campo|
  fill_in campo, with: 'senhaerrada'
end
