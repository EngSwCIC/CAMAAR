# tem como fazer ele preencher as coisas so de uma area? Tipo preenche a area da Q2
When /^I create a question of type "(.*)"$/ do |type|
  case type

  when /^Radio$/
    When %{I press "+"}
    And %{I select "Radio" from "Tipo"}
    And %{I fill in "Texto:" with "q do tipo radio"}
    And %{I fill in "Opções:" with "op1"}

  when /^Texto$/
    When %{I press "+"}
    And %{I select "Texto" from "Tipo"}
    And %{I fill in "Texto:" with "q do tipo texto"}

  else
    raise "Non-existent question type"
  end
end

Given /^I have created a template "(.*)"$/ do |nome|
  Given %{I am on the Templates page}
  When %{I press "+"}
  And %{I fill in I fill in "Nome do template:" with "#{nome}"}
  And %{I create a question of type "Radio"}
  And %{I create a question of type "Texto"}
  And %{I press "Criar"}
end