And("I select the class {string}") do |class_name|
  select(class_name, from: "class")
end

And("I choose the target audience {string}") do |audience|
  choose(audience)
end

And("the form should be available for teachers of {string}") do |class_name|
  expect(page).to have_content("Formulário para docentes de #{class_name}")
end

And("the form should be available for students of {string}") do |class_name|
  expect(page).to have_content("Formulário para discentes de #{class_name}")
end
