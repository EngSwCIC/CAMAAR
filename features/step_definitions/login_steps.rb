Given("the user is on the login page") do
  visit("/login")
end

When("the user fills {field} in the username field") do |field|
  fill_in("username", with: field)
end

When("the user fills {field} in the password field") do |field|
  fill_in("password", with: field)
end

Then("the user should be redirected to the dashboard") do
  expect(page).to have_current_path(dashboard_path)
end

Then("an error message should be displayed with {err}") do |err|
  expect(page).to have_content(err)
end

When("the user leaves {field} field empty") do |field|
  fill_in(field, with: "")
end
And("the user leaves {field} field empty") do |field|
  fill_in(field, with: "")
end