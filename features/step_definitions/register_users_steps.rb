Given('I am logged in as the {string} profile') do |profile|
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
