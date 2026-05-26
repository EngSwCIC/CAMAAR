Given("I am logged in as an admin user") do
  # user validation and login steps
end

Given("I have created a template with the name {string}") do |name|
  # Implementation for creating a template
end

And("I am on the dashboard page") do
  visit("/")
end

And("the list should include {string}") do |template_name|
  expect(page).to have_content(template_name)
end

And("I click on the template named {string}") do |template_name|
  click_link(template_name)
end

And("the details should include the name {string}") do |template_name|
  expect(page).to have_content(template_name)
end

When("I navigate to the templates page") do
  visit("/templates")
end

Then("I should see a list of created templates") do
  expect(page).to have_selector(".template-list")
end

Then("I should see the details of {string}") do |template_name|
  # Implementation for checking the details of the template
end
