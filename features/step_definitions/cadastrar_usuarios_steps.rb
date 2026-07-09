require 'cgi'


# Cenário: [Feliz] Cadastrar usuário com dados válidos
Dado('que eu estou logado no sistema com o perfil de {string}') do |string|
  @user_perfil = string.capitalize

  User.find_or_create_by!(email: "admin@camaar.com") do |user|
    user.nome = @user_perfil
    user.matricula = "000000001"
    user.perfil = @user_perfil
    user.password = "123456"
    user.password_confirmation = "123456"
    user.primeiro_acesso = false
  end

  visit '/'

  fill_in 'E-mail ou matrícula', with: 'admin@camaar.com'
  fill_in 'Senha', with: '123456'

  click_button 'Entrar'

  expect(page).to have_current_path('/admin')
  # expect(page).to have_content('Bem-vindo, #{string}')
end


Dado('que eu acesso a opção de {string} no menu lateral') do |string|
  @opcao_menu = string
  expect(page).to have_link(@opcao_menu) # mudar para have_link ou have_button dependendo do tipo de elemento
  click_link @opcao_menu
end


Quando('eu clico em {string}') do |string|
  @import_usuarios = 'Importar Dados'
  expect(page).to have_content(@import_usuarios) # mudar para have_link ou have_button dependendo do tipo de elemento

  find('label', text: @import_usuarios).click
end

Quando('seleciono um arquivo JSON contendo os dados de novos usuários do SIGAA') do
  find('label', text: @import_usuarios).click
  @arquivo_json = Rails.root.join('class_members.json')

  attach_file('arquivo_json', @arquivo_json, visible: :any)

  click_button('botao_enviar_oculto', visible: false)

  # div_arquivo = find('#secao_importa').trigger('submit')
  # expect(page).to have_content(@import_usuarios) # mudar para have_link ou have_button dependendo do tipo de elemento

  # find('label', text: @import_usuarios).click
end


Quando('os dados estão válidos no arquivo importado') do
  # Validação pelo registro no banco de dados
  expect(Turma.count).to be > 0
  expect(Discente.count).to be > 0
  expect(Docente.count).to be > 0
end


Então('o sistema deve processar o arquivo e criar solicitações de definição de senha para cada usuário novo') do
  expect(ActionMailer::Base.deliveries.count).to eq(0)
end

Então('os usuários devem receber um e-mail com um link para definir suas senhas') do
  @discente_user = User.find_or_create_by!(email: "discente@camaar.com") do |user|
    user.nome = "Discente teste"
    user.matricula = "211025555"
    user.perfil = "Discente"
    user.password = "123456"
    user.password_confirmation = "123456"
    user.primeiro_acesso = true
  end
  expect(ActionMailer::Base.deliveries.count).to be > 0
  @definir_senha_url = "/definir_senha?email=#{CGI.escape(@discente_user.email)}"
end


# Cenário: [Feliz] Usuário permanece pendente enquanto não define a senha
Dado('que um usuário foi cadastrado com sucesso no sistema e recebeu um e-mail para definir a senha') do
  @discente_user = User.find_or_create_by!(email: "discente@camaar.com") do |user|
    user.nome = "Discente teste"
    user.matricula = "211025555"
    user.perfil = "Discente"
    user.password = "123456"
    user.password_confirmation = "123456"
    user.primeiro_acesso = true
  end
  expect(@discente_user.primeiro_acesso).to be(true)
end

Dado('o usuário ainda não definiu sua senha') do
  expect(@discente_user.primeiro_acesso).to be(true)
end

Então('o sistema deve manter o status do usuário como {string}') do |string|
  expect(@discente_user.primeiro_acesso).to be(true)
end

Então('o usuário não deve ter acesso ao sistema até que a senha seja definida') do
  expect(@discente_user.reload.primeiro_acesso).to be(true)
end


# Cenário: [Feliz] Usuário define a senha e é ativado
Dado('o usuário definiu sua senha') do
  @discente_user = User.find_by(email: "discente@camaar.com")
  @discente_user.update!(primeiro_acesso: false, password: "1234567", password_confirmation: "1234567")
end

Então('o sistema deve atualizar o status do usuário para {string}') do
  expect(@discente_user.primeiro_acesso).to be(false)
end

Então('o usuário deve conseguir acessar o sistema com suas credenciais') do
  visit '/'

  fill_in 'E-mail ou matrícula', with: '211025555'
  fill_in 'Senha', with: '1234567'

  click_button 'Entrar'
end


# Cenário: [Triste] Tentar cadastrar usuário já existente
Dado('que estou logado no sistema com o perfil de {string}') do |string|
  @novo_perfil = string
  expect(page).to have_current_path('/admin')
end

Quando('seleciono um arquivo JSON contendo os dados de novos usuários') do
  expect(page).to have_link(@opcao_menu) # mudar para have_link ou have_button dependendo do tipo de elemento
  click_link @opcao_menu

  @import_usuarios = 'Importar Dados'
  expect(page).to have_content(@import_usuarios) # mudar para have_link ou have_button dependendo do tipo de elemento

  find('label', text: @import_usuarios).click

  @arquivo_json = Rails.root.join('class_members.json')

  attach_file('arquivo_json', @arquivo_json, visible: :any)

  click_button('botao_enviar_oculto', visible: false)
end

Quando('os dados estão inválidos no arquivo importado') do
  pending # Write code here that turns the phrase above into concrete actions
end

Então('o sistema deve exibir uma mensagem de erro {string}') do |string|
  erro_msg = string
end

Então('o sistema não deve criar solicitações de definição de senha para os usuários') do
  expect(ActionMailer::Base.deliveries.count).to eq(0)
end


# Cenário: [Triste] Tentar cadastrar usuário já existente
Quando('os dados estão válidos mas correspondem a usuários já existentes no sistema') do
  expect(Turma.count).to eq(0)
  expect(Discente.count).to eq(0)
  expect(Docente.count).to eq(0)
end

Então('o sistema deve exibir uma mensagem de aviso {string}') do |string|
  aviso_msg = string
end

Então('o sistema não deve criar solicitações de definição de senha para os usuários duplicados') do
  expect(page).to have_current_path('/admin')
end
