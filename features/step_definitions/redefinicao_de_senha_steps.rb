Dado('que existe um usuário cadastrado no sistema') do
  @usuario = Pessoa.create!(
    email: "usuario@teste.com",
    password: "SenhaAntiga123",
    password_confirmation: "SenhaAntiga123",
    nome: "Utilizador Teste",
    usuario: "123456789"
  )
end

Dado('que ele já solicitou a troca de senha e recebeu o e-mail com o link de redefinição') do
  @token = SecureRandom.urlsafe_base64
  @usuario.update!(
    reset_password_token: @token,
    reset_password_sent_at: Time.current
  )
end

Quando('o usuario acessa o link valido de redefinicao de senha recebido no e-mail') do
  visit edit_password_path(@token)
end

Quando('informa a nova senha {string}') do |nova_senha|
  @senha_digitada = nova_senha
  fill_in 'pessoa_password', with: nova_senha
end

Quando('confirma a nova senha {string}') do |confirmacao_senha|
  fill_in 'pessoa_password_confirmation', with: confirmacao_senha
end

Quando('envia o formulario de redefinicao de senha') do
  click_button 'Salvar Senha'
end

Então('o sistema deve atualizar a senha do usuario') do
  @usuario.reload
  expect(@usuario.authenticate(@senha_digitada)).to be_truthy
end

Então('deve redirecionar o usuario para a tela de login') do
  expect(current_path).to eq(login_path)
end

Então('deve permitir o acesso ao sistema com a nova senha') do
  fill_in 'login', with: @usuario.email
  fill_in 'password', with: @senha_digitada
  click_button 'Entrar'
  expect([root_path, avaliacoes_path, "/"]).to include(current_path)
end

Então('o sistema nao deve atualizar a senha do usuario') do
  @usuario.reload
  expect(@usuario.authenticate("SenhaAntiga123")).to be_truthy
end

Então('deve exibir a mensagem de erro {string}') do |mensagem_erro|
  if mensagem_erro.include?("conferem") || mensagem_erro.include?("coincidem")
    expect(page.body.downcase).to match(/conferem|coincidem/)
  else
    expect(page.body).to include(mensagem_erro)
  end
end