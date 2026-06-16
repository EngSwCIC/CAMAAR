Given("a SIGAA file containing the new participant {string} is available") do |email|
  @sigaa_participants_file = Rails.root.join("spec/fixtures/sigaa_participant_#{email.split('@').first}.json")
end

And("a SIGAA file containing the participant {string} is available") do |email|
  @sigaa_participants_file = Rails.root.join("spec/fixtures/sigaa_participant_#{email.split('@').first}.json")
end

And("no user is registered with the email {string}") do |email|
  User.where(email: email).destroy_all if defined?(User)
end

When("I upload the SIGAA participants file") do
  attach_file("participants_file", @sigaa_participants_file)
end

Then("the system should create a registration request for {string}") do |email|
  expect(PendingRegistration.where(email: email)).to exist
end

And("a password setup email should be sent to {string}") do |email|
  expect(ActionMailer::Base.deliveries.map(&:to).flatten).to include(email)
end

And("the user {string} should appear with status {string}") do |email, status|
  within(".user-row", text: email) { expect(page).to have_content(status) }
end

Given("there is a pending registration request for {string}") do |email|
  PendingRegistration.create!(email: email, token: SecureRandom.hex(10))
end

When("the user {string} accesses the password setup link received by email") do |email|
  registration = PendingRegistration.find_by(email: email)
  visit "/users/password/define?token=#{registration.token}"
end

And("the user sets the password {string}") do |password|
  fill_in("Senha", with: password)
  fill_in("Confirmação", with: password)
  click_on("Set Password")
end

Then("the registration of {string} should be completed") do |email|
  expect(User.find_by(email: email)).to be_present
end

Then("the system should not send a new email to {string}") do |email|
  expect(ActionMailer::Base.deliveries.map(&:to).flatten).not_to include(email)
end
