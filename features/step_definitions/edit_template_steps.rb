And("I change the template name to {string}") do |new_name|
  fill_in("Name", with: new_name)
end

And("I add a question {string}") do |question|
  click_on("Add Question")
  fill_in("question", with: question)
end

And("the existing form created from {string} should remain unchanged") do |template_name|
  visit("/forms")
  expect(page).to have_content(template_name)
end
