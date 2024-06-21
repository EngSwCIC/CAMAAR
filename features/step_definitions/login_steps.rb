When('I login with the following credentials:') do |table|
  attributes = table.rows_hash # { email: 'foo', password: 'bar' }

  visit login_path
  fill_in :email, with: attributes[:email]
  fill_in :password, with: attributes[:password]
end

Then('I should be logged in to the system as an administrator') do
end
