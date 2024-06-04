Given('I am a registered User') do
  User.create!({
                 email: 'test@gmail.com',
                 password: 'abc123',
                 password_confirmation: 'abc123',
                 confirmed_at: Time.now.utc
               })
end

And('I am on the {string} page') do |page|
  visit path_to(page)
end

# When('I fill in the following')
