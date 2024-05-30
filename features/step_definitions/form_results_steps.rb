Then /^I should not be able to press "(.*)"$/ do |btn|
  expect(page).to have_button(btn, disabled: true)
end

# depois ver como eh a criacao de template pra colocar aqui
Given /^I have sent a form to "(.*)"$/ do |turma|
  Given %{I have created a template "Teste"}
  And %{I am on the Gerenciamento page}
  When %{I press "Enviar Formularios"}
  And %{I select "Teste" from "Template"}
  And %{I check "#{turma}"}
  And %{I press "Enviar"}
end