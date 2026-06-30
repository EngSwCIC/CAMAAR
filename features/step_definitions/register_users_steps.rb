Given('I am logged in as the {string} profile') do |profile|
  admin = User.find_or_initialize_by(email: 'admin@camaar.com')
  admin.nome = 'Administrador' if admin.nome.blank?
  admin.matricula = '000000000' if admin.matricula.blank?
  admin.perfil = 'docente'
  admin.password = 'password123'
  admin.password_confirmation = 'password123'
  admin.save!

  visit(new_user_session_path)
  fill_in('Email', with: 'admin@camaar.com')
  fill_in('Password', with: 'password123')
  click_button('Log in')
end

Given('I am on the user registration page') do
  visit(new_user_path)
end

When('I fill the {string} field with {string}') do |field, value|
  fill_in(field, with: value)
end

When('I select the {string} profile') do |profile|
  select(profile, from: 'Perfil de Acesso')
end

Then('the system should register the new user') do
  expect(page).to have_current_path('/usuarios')
end

Given('a user already exists with email {string}') do |email|
  @existing_user = email
  User.find_or_create_by!(email: email.downcase) do |u|
    u.nome = "Usuário Existente"
    u.matricula = "33333#{rand(1000)}"
    u.perfil = "discente"
    u.password = "password123"
    u.password_confirmation = "password123"
  end
end

Then('the system should not register the user') do
  expect(page).to have_current_path('/usuarios/novo')
end

Then('I should see the error message {string}') do |message|
  expect(page).to have_content(message)
  expect(page).to have_selector('.alert-danger')
end
