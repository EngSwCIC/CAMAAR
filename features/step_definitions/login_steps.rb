When /^I log in with "(.*)" as an e-mail and "(.*)" as a password$/ do |email, senha|
  steps %{When I fill in "Email" with "#{email}"}
  steps %{And I fill in "Senha" with "#{senha}"}
  steps %{And I press "Entrar"}
end

Given('There is a user with email {string} and password {string}') do |email, password|
  @user = User.new(:email => email, :password => password, :password_confirmation => password)
  @user.save!
end