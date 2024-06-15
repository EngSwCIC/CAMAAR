When /^I log in with "(.*)" as the login and "(.*)" as a password$/ do |email, senha|
  steps %{When I fill in "Login" with "#{email}"}
  steps %{And I fill in "Senha" with "#{senha}"}
  steps %{And I press "Entrar"}
end

Given('There is a user with email {string} and matricula {string} and password {string}') do |email, matricula, password|
  @user = User.new(:email => email, :matricula => matricula, :password => password, :password_confirmation => password)
  @user.save!
end