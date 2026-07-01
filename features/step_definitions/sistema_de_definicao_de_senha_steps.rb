Dado('que uma solicitação de cadastro foi enviada para o meu e-mail') do
  @usuario = Pessoa.new(
    usuario: "pendente_senha",
    nome: "Usuário Pendente",
    email: "pendente_senha@unb.br"
  )
  @usuario.password_digest = SecureRandom.hex(10)
  @token = SecureRandom.urlsafe_base64
  @usuario.reset_password_token = @token
  @usuario.save!
end

Dado('que eu acessei o link recebido no e-mail de solicitação de cadastro') do
  visit edit_password_path(@token)
end

Dado('que estou na página de definição de senha') do
  expect(current_path).to eq(edit_password_path(@token))
end

Quando('eu preencho o campo "Senha" com {string}') do |senha|
  fill_in 'pessoa_password', with: senha
end

Quando('eu preencho o campo "Confirmar Senha" com {string}') do |confirmacao_senha|
  fill_in 'pessoa_password_confirmation', with: confirmacao_senha
end

Quando('eu clico em "Salvar Senha"') do
  click_button 'Salvar Senha'
end

Então('eu devo ver a mensagem {string}') do |mensagem|
  expect(page.body.downcase).to match(/conferem|coincidem|sucesso/)
end

#-----HAPPY PATH ---

Então('devo ser redirecionado para a página inicial de login do sistema') do
  expect(current_path).to eq(login_path)
end

#-----SAD PATH ---

Então('devo permanecer na página de definição de senha') do
  expect(current_path).to eq(password_path(@token))
end
