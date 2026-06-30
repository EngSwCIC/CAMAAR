Given("I have a registered account with the email {string}") do |email|
  @registered_email = email
  user = User.find_or_initialize_by(email: email)
  user.nome = "Usuario" if user.nome.blank?
  user.matricula = "222222222" if user.matricula.blank?
  user.perfil = "discente"
  user.password = "OriginalPass123"
  user.password_confirmation = "OriginalPass123"
  user.save!
end

Given("I have requested a password reset for {string}") do |email|
  @reset_email = email
  visit(new_user_password_path)
  fill_in("Email", with: email)
  click_on("Send")
end

And("I have received the reset link in my email") do
  @reset_link = "/password/edit?token=#{SecureRandom.hex(10)}"
end

When("I access the reset link from my email") do
  visit @reset_link
end

When("I access the reset link from my email again") do
  visit @reset_link
end

And("I fill in the new password field with {string}") do |password|
  @new_password = password
  fill_in("Nova Senha", with: password)
end

And("I fill in the confirmation field with {string}") do |password|
  fill_in("Confirmar Senha", with: password)
end

Then("I should see a confirmation message {string}") do |message|
  expect(page).to have_content(message)
end

Then("I should see an error message {string}") do |message|
  expect(page).to have_content(message)
end

And("I should be redirected to the login page") do
  expect(page).to have_current_path(new_user_session_path)
end

And("I should be able to log in with {string} and {string}") do |email, password|
  visit new_user_session_path
  fill_in("Email", with: email)
  fill_in("Password", with: password)
  click_button("Log in")
  expect(page).to have_current_path('/')
end

And("my password should remain unchanged") do
  user = User.find_by(email: @registered_email)
  expect(user.valid_password?("OriginalPass123")).to be true
end

Given("the reset link has expired") do
  @reset_link = "/password/edit?token=expired"
end

And("I should see an option to {string}") do |option|
  expect(page).to have_link(option)
end

Given("I have already redefined my password using the reset link") do
  visit @reset_link
  fill_in("Nova Senha", with: "NovaSenha123")
  fill_in("Confirmar Senha", with: "NovaSenha123")
  click_on("Reset Password")
end
