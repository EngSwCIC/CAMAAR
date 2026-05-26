Given('I am logged in as the {string} profile') do |profile|
  visit '/login'
  fill_in 'Usuário', with: 'admin'
  fill_in 'Senha', with: 'admin123'
  click_button 'Login'
end

Given('I am on the user registration page') do
  visit '/usuarios/novo'
end

When('I fill the {string} field with {string}') do |field, value|
  fill_in field, with: value
end

When('I select the {string} profile') do |profile|
  select profile, from: 'Perfil de Acesso'
end

When('I click the {string} button') do |button|
  click_button button
end

Then('the system should register the new user') do
  expect(page).to have_current_path('/usuarios')
end

Then('I should see the green message {string}') do |message|
  expect(page).to have_content(message)
  expect(page).to have_selector('.alert-success')
end

Given('a user already exists with email {string}') do |email|
  @existing_user = email
end

Then('the system should not register the user') do
  expect(page).to have_current_path('/usuarios/novo')
end

Then('I should see the error message {string}') do |message|
  expect(page).to have_content(message)
  expect(page).to have_selector('.alert-danger')
end
