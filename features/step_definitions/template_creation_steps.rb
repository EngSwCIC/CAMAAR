# tem como fazer ele preencher as coisas so de uma area? Tipo preenche a area da Q2
# o "Big +" seria o botao + externo que coloca mais questoes
When /^I create a text question with the question "(.*)"$/ do |pergunta|
  steps %{When I press "Big +"}
  steps %{And I select "Texto" from "Tipo:"}
  steps %{And I fill in "Texto:" with "#{pergunta}"}
end

# nao sei como eu faria pra 2 alternativas
When /^I create a radio question with the question "(.*)" and 1 alternative: "(.*)"$/ do |pergunta, alt1|
  steps %{When I press "Big +"}
  steps %{And I select "Radio" from "Tipo"}
  steps %{And I fill in "Texto:" with "#{pergunta}"}
  steps %{And I fill in "Opções:" with "#{alt1}"}
end

Given /^I have created a template "(.*)"$/ do |nome|
  steps %{Given I am on the Templates page}
  steps %{When I press "+"}
  steps %{And I fill in "Nome do template:" with "#{nome}"}
  steps %{And I create a radio question with the question "radio?" and 1 alternative: "sim"}
  steps %{And I create a text question with the question "texto?"}
  steps %{And I press "Criar"}
end