Then /^I should not be able to press "(.*)"$/ do |btn|
  expect(page).to have_button(btn, disabled: true)
end

# depois ver como eh a criacao de template pra colocar aqui
Given /^I have sent a form to "(.*)"$/ do |turma|
  steps %{Given I have created a template "Teste"}
  steps %{And I am on the Gerenciamento page}
  steps %{When I press "Enviar Formularios"}
  steps %{And I select "Teste" from "Template"}
  steps %{And I check "#{turma}"}
  steps %{And I press "Enviar"}
end