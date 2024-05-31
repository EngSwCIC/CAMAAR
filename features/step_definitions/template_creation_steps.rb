# tem como fazer ele preencher as coisas so de uma area? Tipo preenche a area da Q2
# o "Big +" seria o botao + externo que coloca mais questoes
When /^I create a text question with the question "(.*)"$/ do |pergunta|
  When %{I press "Big +"}
  And %{I select "Texto" from "Tipo:"}
  And %{I fill in "Texto:" with "#{pergunta}"}
end

# nao sei como eu faria pra 2 alternativas
When /^I create a radio question with the question "(.*)" and 1 alternative: "(.*)"$/ do |pergunta, alt1|
  When %{I press "Big +"}
  And %{I select "Radio" from "Tipo"}
  And %{I fill in "Texto:" with "#{pergunta}"}
  And %{I fill in "Opções:" with "#{alt1}"}
end

Given /^I have created a template "(.*)"$/ do |nome|
  Given %{I am on the Templates page}
  When %{I press "+"}
  And %{I fill in "Nome do template:" with "#{nome}"}
  And %{I create a radio question with the question "radio?" and 1 alternative: "sim"}
  And %{I create a text question with the question "texto?"}
  And %{I press "Criar"}
end