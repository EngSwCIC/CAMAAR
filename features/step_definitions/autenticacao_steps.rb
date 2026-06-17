# frozen_string_literal: nil

# --- Context Helpers / User Creation ---

Dado('que existe um usuário discente com e-mail {string} e senha {string}') do |email, password|
  @discente = Usuario.find_or_initialize_by(email: email)
  @discente.nome ||= "Discente Teste"
  @discente.matricula ||= "232000000"
  @discente.perfil = "discente"
  @discente.ativo = true
  @discente.password = password
  @discente.save!
end

Dado('que existe um usuário docente com e-mail {string} e senha {string}') do |email, password|
  @docente = Usuario.find_or_initialize_by(email: email)
  @docente.nome ||= "Docente Teste"
  @docente.matricula ||= "10002000"
  @docente.perfil = "docente"
  @docente.ativo = true
  @docente.password = password
  @docente.save!
end

Dado('que existe um usuário administrador com e-mail {string} e senha {string}') do |email, password|
  @admin = Usuario.find_or_initialize_by(email: email)
  @admin.nome ||= "Admin Teste"
  @admin.matricula ||= "admin_matricula"
  @admin.perfil = "administrador"
  @admin.ativo = true
  @admin.password = password
  @admin.save!
end

Dado('que existe um usuário com matrícula {string} e senha {string}') do |matricula, password|
  @user_mat = Usuario.find_or_initialize_by(matricula: matricula)
  @user_mat.nome ||= "Matricula Teste"
  @user_mat.email ||= "matricula@unb.br"
  @user_mat.perfil = "discente"
  @user_mat.ativo = true
  @user_mat.password = password
  @user_mat.save!
end

Dado('que existe um usuário inativo com e-mail {string} e senha {string}') do |email, password|
  @inativo = Usuario.find_or_initialize_by(email: email)
  @inativo.nome ||= "Inativo Teste"
  @inativo.matricula ||= "99999999"
  @inativo.perfil = "discente"
  @inativo.ativo = false
  @inativo.password = password
  @inativo.save!
end

Dado('que existe um usuário cadastrado pelo administrador com e-mail {string} sem senha definida') do |email|
  @new_user = Usuario.find_or_initialize_by(email: email)
  @new_user.nome ||= "Novo Teste"
  @new_user.matricula ||= "998877"
  @new_user.perfil = "discente"
  @new_user.ativo = false
  @new_user.senha_hash = "" # empty
  @new_user.save!(validate: false)
end

Dado('que existe um usuário cadastrado com e-mail {string} e senha {string}') do |email, password|
  @user = Usuario.find_or_initialize_by(email: email)
  @user.nome ||= "Recupera Teste"
  @user.matricula ||= "88776655"
  @user.perfil = "discente"
  @user.ativo = true
  @user.password = password
  @user.save!
end


# --- Navigation / Page Visits ---

Dado('que estou na página de login') do
  visit login_path
end

Quando('acesso a página de login') do
  visit login_path
end

Dado('que estou na página de esqueci minha senha') do
  visit forgot_password_path
end

Quando('acesso a página de definição de senha') do
  visit setup_password_path(token: @token)
end

Dado('que acesso a página de definição de senha') do
  visit setup_password_path(token: @token)
end

Quando('acesso a página de redefinição de senha') do
  visit reset_password_path(token: @token)
end


# --- Forms and Actions ---

Quando('preencho {string} com {string}') do |field, value|
  fill_in field, with: value
end

Quando('preencho {string} com {string}{string}') do |field, val1, val2|
  fill_in field, with: "#{val1}#{val2}"
end


# --- Redirection & View Assertions ---

Então('devo ser redirecionado para a minha página inicial') do
  # Page after login is either /avaliacoes or /admin/dashboard
  expect(current_path).to eq(avaliacoes_path).or eq(admin_dashboard_path)
end

Então('devo ver o menu de navegação') do
  expect(page).to have_css('aside#main-sidebar')
end

Então('devo ver a opção de gerenciamento no menu lateral') do
  expect(page).to have_content('Gerenciamento')
end

Então('devo permanecer na página de login') do
  expect(current_path).to eq(login_path)
end

Então('devo ser redirecionado para a página de login') do
  expect(current_path).to eq(login_path)
end

Então('devo permanecer na página de definição de senha') do
  expect(current_path).to eq(setup_password_path)
end

Então('não devo ver o formulário de definição de senha') do
  expect(page).not_to have_button("Definir senha")
end

Então('devo permanecer na página de esqueci minha senha') do
  expect(current_path).to eq(forgot_password_path)
end

Então('devo permanecer na página de redefinição de senha') do
  expect(current_path).to eq(reset_password_path)
end

Então('não devo ver o formulário de redefinição de senha') do
  expect(page).not_to have_button("Redefinir senha")
end


# --- Setup & Tokens ---

Dado('que esse usuário recebeu um e-mail com link de definição de senha') do
  @new_user.generate_setup_token!
end

Dado('que possuo um token de definição de senha válido') do
  @new_user ||= Usuario.find_by(email: "novo@unb.br")
  @new_user.generate_setup_token!
  @token = @new_user.setup_token
end

Dado('que possuo um token de definição de senha que expirou há 24 horas') do
  @new_user ||= Usuario.find_by(email: "novo@unb.br")
  @new_user.generate_setup_token!
  @new_user.update_columns(setup_token_sent_at: 25.hours.ago)
  @token = @new_user.setup_token
end

Dado('que possuo um token de definição de senha inválido ou corrompido') do
  @token = "invalid_token"
end

Dado('que possuo um token de definição de senha que já foi processado') do
  @new_user ||= Usuario.find_by(email: "novo@unb.br")
  @new_user.generate_setup_token!
  @new_user.update_columns(setup_token_used: true)
  @token = @new_user.setup_token
end

Dado('que o usuário {string} solicitou redefinição de senha') do |email|
  @user = Usuario.find_by(email: email)
  @user.generate_reset_token!
end

Dado('que possuo um token de redefinição de senha válido') do
  @user ||= Usuario.find_by(email: "usuario@unb.br")
  @user.generate_reset_token!
  @token = @user.reset_token
end

Dado('que o usuário {string} redefiniu a senha para {string}') do |email, new_password|
  u = Usuario.find_by(email: email)
  u.password = new_password
  u.save!
end

Dado('que possuo um token de redefinição de senha expirado') do
  @user ||= Usuario.find_by(email: "usuario@unb.br")
  @user.generate_reset_token!
  @user.update_columns(reset_token_sent_at: 25.hours.ago)
  @token = @user.reset_token
end

Dado('que possuo um token de redefinição de senha inválido') do
  @token = "invalid_token"
end

Dado('que o token de redefinição de senha já foi utilizado anteriormente') do
  @user ||= Usuario.find_by(email: "usuario@unb.br")
  @user.generate_reset_token!
  @user.update_columns(reset_token_used: true)
  @token = @user.reset_token
end
