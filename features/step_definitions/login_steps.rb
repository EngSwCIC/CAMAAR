When('I login with default administrator credentials') do
  step 'logged in as an administrator'
  expect(page).to have_text 'Avaliações Disponíveis'
end
# TODO: on login fail, expect(page).to have_text 'Email e Senha devem ser prenchidos'

Then('I should be logged in to the system as an administrator') do
end
