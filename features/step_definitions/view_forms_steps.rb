Given("I have created a form called {string}") do |form_name|
  @forms ||= []
  @forms << form_name
end

When("I navigate to the forms page") do
  visit("/forms")
end

Then("I should see a list of created forms") do
  expect(page).to have_selector(".forms-list")
end

And("I click on the form named {string}") do |form_name|
  click_link(form_name)
end

Then("I should see a message {string}") do |message|
  expect(page).to have_content(message)
end
