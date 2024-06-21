When('I login with the following credentials:') do |table|
  attributes = table.rows_hash # { email: 'foo', password: 'bar' }

  puts attributes.inspect
  visit login_path
  fill_in :email, with: attributes[:email]
  fill_in :password, with: attributes[:password]
  puts 'email:', find_field(:email).value
  puts 'pass:', find_field(:password).value
  click_button 'Entrar'
  expect(page).to have_text 'Avaliações Disponíveis'
end
# TODO: on login fail, expect(page).to have_text 'Email e Senha devem ser prenchidos'

Then('I should be logged in to the system as an administrator') do
end
