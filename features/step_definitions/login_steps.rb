When /^I log in with "(.*)" as an e-mail and "(.*)" as a password$/ do |email, senha|
  steps %{When I fill in "Email" with "#{email}"}
  steps %{And I fill in "Senha" with "#{senha}"}
  steps %{And I press "Entrar"}
end