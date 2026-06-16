Given("I am on the {page} page") do |page|
  visit path_to(page)
end

And("I click on {button}") do |button|
  click_on(button)
end

And("I fill {email} in the email field") do |email|
  fill_in("Email", with: email)
end

Then("I should be on the {page} page") do |page|
  visit path_to(page)
end

And("I fill in the password field with {password}") do |password|
  fill_in("Password", with: password)
end

Then("I should see a {message} message") do |message|
  expect(page).to have_content(message)
end