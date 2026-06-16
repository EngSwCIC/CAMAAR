Given("I am on the login page") do
  visit(new_user_session_path)
end

Given("the following users exist:") do |table|
  table.hashes.each do |user_data|
    User.find_or_create_by!(email: user_data['email']) do |user|
      user.password = user_data['password']
      user.perfil = user_data['perfil']
      user.save!
    end
  end
end

When("I fill {string} in the username field") do |field|
  fill_in("Email", with: field)
end

When("I fill {string} in the password field") do |field|
  fill_in("Password", with: field)
  click_button("Log in")
end

Then("I should be redirected to the dashboard") do
  expect(page).to have_current_path('/')
end

When("I leave {string} field empty") do |field|
end