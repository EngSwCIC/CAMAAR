Given(/^(?:I )?login with @credentials$/) do
  visit login_path
  fill_in :email, with: @credentials[:email]
  fill_in :password, with: @credentials[:password]
  click_button 'Entrar'
end

Given(/^(?:I am logged in as|I am) an administrator$/) do
  step 'a valid administrator'

  @credentials = {
    email: 'coordenador@gmail.com',
    password: 'TOKEN_587'
  }
  step 'I login with @credentials'
end

Given(/^(?:I am logged in as|I am) a (?:student|user)?$/) do
  step 'a valid user'

  @credentials = {
    email: 'vanessa@gmail.com',
    password: 'TOKEN_587'
  }
  step 'I login with @credentials'
end

When(/^I login with (?:the )?default administrator credentials$/) do
  step 'I am logged in as an administrator'
end

When(/^I login with (?:the )?default user credentials$/) do
  step 'I am logged in as a student'
end

When('I login with the credentials:') do |t|
  @credentials = t.rows_hash
  step 'login with @credentials'
end

When('I log out') do
  click_button 'Logout'
end

Then('I should be logged in to the system as an administrator') do
  expect(page).to have_text 'Área do Gestor'
end

Then('I should be logged in to the system as a user') do
  expect(page).not_to have_text 'Área do Gestor'
end

Then(/^(?:the )?login should fail$/) do
  expect(page).to have_text 'Email ou Senha estão errados'
end
