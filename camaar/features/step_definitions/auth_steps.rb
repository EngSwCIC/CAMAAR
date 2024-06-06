Given('I am a registered User') do
  User.create!({
                 email: 'test@gmail.com',
                 password: 'abc123',
                 password_confirmation: 'abc123',
                 confirmed_at: Time.now.utc
               })
end


# When('I fill in the following')
