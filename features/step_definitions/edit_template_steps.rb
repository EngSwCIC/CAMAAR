And("I change the template name to {string}") do |new_name|
  fill_in("Nome", with: new_name)
end

And("I add an open-ended question {string}") do |question|
  click_on("+ Adicionar questão")
  fill_in("Enunciado", with: question, match: :first)
end

And("the existing form created from {string} should remain unchanged") do |template_name|
  visit("/formularios")
  expect(page).to have_content(template_name)
end
