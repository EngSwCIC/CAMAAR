Given("I am on the CAMAAR login page") do
  visit "/login"
end

Given("a regular user exists with email {string} and password {string}") do |email, password|
  User.find_or_create_by(email: email) do |u|
    u.password = password
    u.role = "user"
  end
end

Given("a user exists with registration number {string} and password {string}") do |registration, password|
  User.find_or_create_by(matricula: registration) do |u|
    u.password = password
    u.role = "user"
  end
end

Given("an administrator exists with email {string} and password {string}") do |email, password|
  User.find_or_create_by(email: email) do |u|
    u.password = password
    u.role = "admin"
  end
end

When("I fill the identification field with {string}") do |value|
  fill_in("Identificação", with: value)
end

And("I fill the password field with {string}") do |value|
  fill_in("Senha", with: value)
end

Then("I should be redirected to the CAMAAR dashboard") do
  expect(page).to have_current_path("/dashboard")
end

Then("I should see the {string} option in the side menu") do |option|
  within(".sidebar-menu") { expect(page).to have_content(option) }
end

Then("I should not see the {string} option in the side menu") do |option|
  within(".sidebar-menu") { expect(page).not_to have_content(option) }
end
