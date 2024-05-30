When /^I fill "(.*)" with "(.*)"$/ do |field, value|
  fill_in(field, with: value)
end

When /^I fill in the login page with "(.*)" as an e-mail and "(.*)" as a password$/ do |email, senha|
  When %{I fill in "Email" with "#{email}"}
  When %{I fill in "Senha" with "#{senha}"}
end
