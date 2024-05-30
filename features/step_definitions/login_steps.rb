When /^I log in with "(.*)" as an e-mail and "(.*)" as a password$/ do |email, senha|
  When %{I fill in "Email" with "#{email}"}
  And %{I fill in "Senha" with "#{senha}"}
  And %{I press "Entrar"}
end