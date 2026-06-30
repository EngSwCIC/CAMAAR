Given("the user is on the login page") do
  visit(new_user_session_path)
end

Given("there is a user with email {string} and password {string}") do |email, password|
  user = User.find_or_create_by(email: email) do |u|
    u.nome = "Aluno"
    u.matricula = "999999999"
    u.perfil = "discente"
    u.password = password
    u.password_confirmation = password
  end
  user.save!
end

Given("there is an administrator with email {string} and password {string}") do |email, password|
  admin = User.find_or_create_by(email: email) do |u|
    u.nome = "Administrador"
    u.matricula = "000000000"
    u.perfil = "docente"
    u.password = password
    u.password_confirmation = password
  end
  admin.save!
end

When("the user fills {string} in the username field") do |field|
  fill_in("Email", with: field)
end

When("the user fills {string} in the password field") do |field|
  fill_in("Password", with: field)
end

Then("the user should be redirected to the dashboard") do
  expect(page).to have_current_path('/')
end

Then("an error message should be displayed with {err}") do |err|
  expect(page).to have_content(err)
end

When("the user leaves {string} field empty") do |field|
  fill_in(field, with: "")
end

And("the user clicks {string} button") do |button|
  click_button(button)
end

Then("the user should see {string}") do |content|
  expect(page).to have_content(content)
end

Then("the user should not see {string}") do |content|
  expect(page).not_to have_content(content)
end
