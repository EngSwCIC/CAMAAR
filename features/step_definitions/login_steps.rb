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
