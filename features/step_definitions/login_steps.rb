Given(/^(?:I )?login with @credentials$/) do
  visit login_path
  fill_in :email, with: @credentials[:email]
  fill_in :password, with: @credentials[:password]
  click_button 'Entrar'
end

Given(/^(?:I am logged in as|I am)? an administrator$/) do
  step 'a valid administrator'

  @credentials = {
    email: 'coordenador@gmail.com',
    password: 'TOKEN_587'
  }
  step 'I login with @credentials'
end

When('I login with default administrator credentials') do
  step 'logged in as an administrator'
end

When('I login with the credentials:') do |t|
  @credentials = t.rows_hash
  step 'login with @credentials'
end

Then('I should be logged in to the system as an administrator') do
  expect(page).to have_text 'Avaliações Disponíveis'
end

Then(/^(?:the )?login should fail$/) do
  expect(page).to have_text 'Email ou Senha estão errados'
end
