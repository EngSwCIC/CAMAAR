Dado('que o e-mail de usuário {string} está cadastrado no sistema com senha indefinida') do |email|
  usuario = Usuario.find_or_initialize_by(email: email)
  usuario.matricula ||= "#{rand(100000..999999)}"
  usuario.nome ||= "Usuário Teste"
  usuario.senha_hash = nil
  usuario.save!
end

Quando('eu acesso o link de definição de senha recebido por e-mail') do
  email_destino = @email_destino || raise("Email de destino não definido nos steps")

  mensagem = ActionMailer::Base.deliveries.reverse.find { |m| m.to == [ email_destino ] }
  raise("Nenhum email enviado para #{email_destino}") if mensagem.nil?

  corpo = mensagem.text_part&.body&.decoded || mensagem.html_part&.body&.decoded || mensagem.body.decoded
  url = corpo[%r{https?://\S+}]
  raise("Não encontrei URL no email") if url.nil?

  visit url
end

Quando('eu informo a nova senha {string} e confirmo a senha {string}') do |senha, confirmacao|
  fill_in "senha", with: senha
  fill_in "senha_confirmation", with: confirmacao
end

Quando('eu confirmo a definição de senha') do
  click_button "Definir senha"
end

Quando('eu informo o email {string}') do |email|
  fill_in "email", with: email
end

Quando('eu solicito a redefinição de senha') do
  click_button "Solicitar redefinição"
end

Quando('eu solicito a redefinição de senha sem informar meu email') do
  click_button "Solicitar redefinição"
end

Então('um email de redefinição de senha é enviado para o email {string}') do |email|
  usuario = Usuario.find_by!(email: email)
  ActionMailer::Base.deliveries.clear
  usuario.enviar_email_redefinicao_senha!

  @email_destino = email

  enviados = ActionMailer::Base.deliveries.select { |m| m.to == [ email ] }
  expect(enviados).not_to be_empty
end

Dado('que eu solicitei a redefinição de senha para o email {string}') do |email|
  usuario = Usuario.find_by!(email: email)
  ActionMailer::Base.deliveries.clear
  usuario.enviar_email_redefinicao_senha!
  @email_destino = email
end

Quando('eu acesso o link de redefinição de senha recebido por e-mail') do
  email_destino = @email_destino || raise("Email de destino não definido nos steps")

  mensagem = ActionMailer::Base.deliveries.reverse.find { |m| m.to == [ email_destino ] }
  raise("Nenhum email enviado para #{email_destino}") if mensagem.nil?

  corpo = mensagem.text_part&.body&.decoded || mensagem.html_part&.body&.decoded || mensagem.body.decoded
  url = corpo[%r{https?://\S+}]
  raise("Não encontrei URL no email") if url.nil?

  visit url
end

Quando('eu confirmo a redefinição de senha') do
  click_button "Redefinir senha"
end
