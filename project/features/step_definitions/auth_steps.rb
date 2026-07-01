Before("@auth") do
  ActionMailer::Base.deliveries.clear
end

After("@auth") do
  File.delete(@temporary_import_path) if @temporary_import_path.present? && File.exist?(@temporary_import_path)
end

Dado("que existe um administrador autenticado do departamento {string}") do |department_code|
  department = Department.find_or_create_by!(code: department_code) { |record| record.name = department_code }
  @current_admin = User.create!(
    name: "Administrador #{department_code}",
    email: "admin.#{department_code.downcase}@unb.br",
    registration: "000000001",
    role: :admin,
    department:,
    password: "Senha@123"
  )
end

Dado("que o arquivo {string} contem participantes da turma {string} no semestre {string}") do |file_name, class_code, semester|
  @import_path = Rails.root.join("..", file_name)
  expect(JSON.parse(File.read(@import_path))).to include(a_hash_including("code" => class_code, "semester" => semester))
end

Quando("o administrador importa os participantes do SIGAA") do
  @import_result = Sigaa::ClassMembersImporter.new(path: @import_path, imported_by: @current_admin).call
end

Quando("o administrador importa novamente os participantes do SIGAA") do
  step "o administrador importa os participantes do SIGAA"
end

Entao("o sistema deve cadastrar o usuario {string} com email {string} e matricula {string}") do |name, email, registration|
  @last_user = User.find_by!(email:, registration:)
  expect(@last_user.name).to eq(name)
end

Entao("deve associar o usuario a turma {string} como participante discente") do |class_code|
  expect(@last_user.course_classes.where(code: class_code)).to exist
  expect(@last_user.class_memberships.discente).to exist
end

Entao("deve marcar o usuario como pendente de definicao de senha") do
  expect(@last_user).to be_pending_password_setup
end

Entao("deve enviar email com link de definicao de senha para {string}") do |email|
  message = ActionMailer::Base.deliveries.find { |delivery| delivery.to.include?(email) }
  expect(message).to be_present
  expect(message.body.encoded).to include("senha/definir")
end

Dado("que ja existe um usuario cadastrado com email {string} e matricula {string}") do |email, registration|
  User.create!(
    name: "Usuario Existente",
    email:,
    registration:,
    role: :participant,
    department: Department.find_or_create_by!(code: "CIC") { |record| record.name = "CIC" },
    password: "Senha@123"
  )
end

Entao("o sistema nao deve criar outro usuario com a matricula {string}") do |registration|
  expect(User.where(registration:).count).to eq(1)
end

Entao("deve manter uma unica conta para o email {string}") do |email|
  expect(User.where(email:).count).to eq(1)
end

Entao("deve atualizar os vinculos de turma quando necessario") do
  expect(User.find_by!(email: "acjpjvjp@gmail.com").course_classes).not_to be_empty
end

Dado("que o arquivo de importacao contem um participante sem email ou matricula") do
  @temporary_import_path = Rails.root.join("tmp", "cucumber_class_members.json")
  @import_path = @temporary_import_path
  payload = [
    {
      "code" => "CIC0097",
      "classCode" => "TA",
      "semester" => "2021.2",
      "dicente" => [
        { "nome" => "Participante Invalido", "matricula" => "", "email" => "" },
        { "nome" => "Ana Clara Jordao Perna", "matricula" => "190084006", "email" => "acjpjvjp@gmail.com" }
      ]
    }
  ]
  File.write(@temporary_import_path, JSON.pretty_generate(payload))
end

Entao("o sistema nao deve criar conta para o participante invalido") do
  expect(User.where(name: "Participante Invalido")).not_to exist
end

Entao("deve registrar a inconsistencia encontrada na importacao") do
  expect(ImportInconsistency.where(message: "Participante sem email ou matricula")).to exist
end

Entao("deve continuar processando os demais participantes validos") do
  expect(User.where(registration: "190084006")).to exist
end

Dado("que existe um administrador cadastrado com email {string}, matricula {string} e senha definida {string}") do |email, registration, password|
  User.create!(
    name: "Administrador CIC",
    email:,
    registration:,
    role: :admin,
    department: Department.find_or_create_by!(code: "CIC") { |record| record.name = "CIC" },
    password:
  )
end

Dado("que existe um participante cadastrado com email {string}, matricula {string} e senha definida {string}") do |email, registration, password|
  @user = User.create!(
    name: "Participante",
    email:,
    registration:,
    role: :participant,
    department: Department.find_or_create_by!(code: "CIC") { |record| record.name = "CIC" },
    password:
  )
end

Dado("que existe um participante cadastrado com email {string}, matricula {string} e sem senha definida") do |email, registration|
  User.create!(
    name: "Participante sem senha",
    email:,
    registration:,
    role: :participant,
    department: Department.find_or_create_by!(code: "CIC") { |record| record.name = "CIC" }
  )
end

Quando("o usuario acessa a pagina de login") do
  visit login_path
end

Quando("informa o identificador {string}") do |identifier|
  fill_in "Email ou matricula", with: identifier
end

Quando("informa a senha {string}") do |password|
  fill_in "Senha", with: password
end

Quando("envia o formulario de login") do
  click_button "Entrar"
end

Entao("o sistema deve autenticar o administrador") do
  expect(page).to have_content("Login realizado com sucesso")
  expect(page).to have_content("Administrador CIC")
end

Entao("deve exibir o menu lateral com opcoes de gerenciamento") do
  expect(page).to have_content("Gerenciar templates")
  expect(page).to have_content("Gerenciar formularios")
end

Entao("o sistema deve autenticar o participante") do
  expect(page).to have_content("Login realizado com sucesso")
end

Entao("deve exibir o menu lateral com formularios pendentes") do
  expect(page).to have_content("Formularios pendentes")
end

Entao("nao deve exibir opcoes administrativas") do
  expect(page).not_to have_content("Gerenciar templates")
end

Entao("o sistema nao deve autenticar o usuario") do
  expect(page).not_to have_content("Login realizado com sucesso")
end

Entao("deve exibir a mensagem {string}") do |message|
  expect(page).to have_content(message)
end

Entao("deve informar que a senha inicial precisa ser definida antes do acesso") do
  expect(page).to have_content("Senha inicial precisa ser definida antes do acesso")
end

Dado("que existe um participante importado do SIGAA com email {string}, matricula {string} e sem senha definida") do |email, registration|
  @user = User.create!(
    name: "Ana Clara Jordao Perna",
    email:,
    registration:,
    role: :participant,
    department: Department.find_or_create_by!(code: "CIC") { |record| record.name = "CIC" }
  )
end

Dado("que o sistema enviou um link valido de definicao de senha para {string}") do |email|
  user = User.find_by!(email:)
  @setup_token = user.generate_password_setup_token!
  UserMailer.password_setup(user, @setup_token).deliver_now
end

Quando("o usuario acessa o link valido de definicao de senha") do
  @old_password_digest = @user.reload.password_digest
  visit edit_password_setup_path(@setup_token)
end

Quando("informa a nova senha {string}") do |password|
  @new_password = password
  fill_in "Nova senha", with: password if page.has_field?("Nova senha")
end

Quando("confirma a nova senha {string}") do |password|
  @new_password_confirmation = password
  fill_in "Confirmacao de senha", with: password if page.has_field?("Confirmacao de senha")
end

Quando("envia o formulario de definicao de senha") do
  click_button "Definir senha"
end

Entao("o sistema deve salvar a senha do usuario") do
  expect(@user.reload.password_digest).to be_present
  expect(@user.password_digest).not_to eq(@old_password_digest)
end

Entao("deve ativar o acesso do usuario ao CAMAAR") do
  expect(@user.reload).not_to be_pending_password_setup
end

Entao("deve permitir login com email ou matricula e a nova senha") do
  visit login_path
  fill_in "Email ou matricula", with: @user.email
  fill_in "Senha", with: "Senha@123"
  click_button "Entrar"
  expect(page).to have_content("Login realizado com sucesso")
end

Quando("o usuario acessa um link invalido de definicao de senha") do
  visit edit_password_setup_path("token-invalido")
end

Entao("o sistema nao deve permitir a definicao de senha") do
  expect(page).to have_content("Link de definição de senha inválido ou expirado")
end

Entao("o sistema nao deve salvar a senha do usuario") do
  expect(@user.reload.password_digest).to eq(@old_password_digest)
end

Quando("o usuario acessa a pagina de esqueci minha senha") do
  visit new_password_reset_path
end

Quando("informa o email {string}") do |email|
  fill_in "Email", with: email
end

Quando("solicita a redefinicao de senha") do
  click_button "Solicitar redefinicao de senha"
end

Entao("o sistema deve enviar um email com link de redefinicao para {string}") do |email|
  @reset_email = ActionMailer::Base.deliveries.find { |delivery| delivery.to.include?(email) }
  expect(@reset_email).to be_present
  expect(@reset_email.body.encoded).to include("senha/redefinir")
end

Quando("o usuario acessa o link valido de redefinicao de senha") do
  @old_password_digest = @user.reload.password_digest
  @reset_token = @reset_email.body.encoded.match(%r{senha/redefinir/([^"\s<]+)})[1]
  visit edit_password_reset_path(@reset_token)
end

Quando("envia o formulario de redefinicao de senha") do
  click_button "Redefinir senha" if page.has_button?("Redefinir senha")
end

Entao("o sistema deve atualizar a senha do usuario") do
  expect(@user.reload.password_digest).to be_present
  expect(@user.password_digest).not_to eq(@old_password_digest)
end

Entao("deve permitir login com a nova senha") do
  visit login_path
  fill_in "Email ou matricula", with: @user.email
  fill_in "Senha", with: "NovaSenha@123"
  click_button "Entrar"
  expect(page).to have_content("Login realizado com sucesso")
end

Entao("o sistema deve exibir uma mensagem generica de instrucao") do
  expect(page).to have_content(PasswordResetsController::GENERIC_MESSAGE)
end

Entao("nao deve revelar se o email esta cadastrado") do
  expect(page).not_to have_content("nao cadastrado")
  expect(page).not_to have_content("inexistente")
end

Entao("nao deve criar token de redefinicao para usuario inexistente") do
  expect(User.where.not(password_reset_token_digest: nil)).not_to exist
end

Dado("que existe um link expirado de redefinicao de senha para {string}") do |email|
  @user = User.find_by!(email:)
  @old_password_digest = @user.password_digest
  @reset_token = @user.generate_password_reset_token!
  @user.update!(password_reset_sent_at: 3.hours.ago)
end

Quando("o usuario acessa o link expirado de redefinicao de senha") do
  visit edit_password_reset_path(@reset_token)
end

Entao("o sistema nao deve atualizar a senha do usuario") do
  expect(@user.reload.password_digest).to eq(@old_password_digest)
end
