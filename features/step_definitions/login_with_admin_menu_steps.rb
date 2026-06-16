Given("I am on the CAMAAR login page") do
  visit(new_user_session_path)
end

Given("a regular user exists with email {string} and password {string}") do |email, password|
  user = User.find_or_create_by(email: email) { |u| u.perfil = "discente" }
  user.nome = "Aluno" if user.nome.blank?
  user.matricula = "111111111" if user.matricula.blank?
  user.password = password
  user.password_confirmation = password
  user.save!
end

Given("an administrator exists with email {string} and password {string}") do |email, password|
  user = User.find_or_create_by(email: email) { |u| u.perfil = "docente" }
  user.nome = "Administrador" if user.nome.blank?
  user.matricula = "222222222" if user.matricula.blank?
  user.password = password
  user.password_confirmation = password
  user.save!
end

When("I fill the identification field with {string}") do |value|
  fill_in("Email", with: value)
end

And("I fill the password field with {string}") do |value|
  fill_in("Password", with: value)
end

Then("I should be redirected to the CAMAAR dashboard") do
  expect(page).to have_current_path("/")
end

Then("I should see the {string} option in the side menu") do |option|
  within(".sidebar-menu") { expect(page).to have_content(option) }
end

Then("I should not see the {string} option in the side menu") do |option|
  within(".sidebar-menu") { expect(page).not_to have_content(option) }
end
