Given("I am logged in as a participant user") do
  user = User.find_or_create_by(email: "participant@unb.br") { |u| u.role = "participant" }
  login_as(user, scope: :user)
end

And("I am enrolled in the class {string}") do |class_name|
  @enrolled_classes ||= []
  @enrolled_classes << class_name
end

Given("there is an unanswered form {string} for the class {string}") do |form_name, class_name|
  @unanswered_forms ||= {}
  @unanswered_forms[form_name] = class_name
end

And("I have already answered the form {string} for the class {string}") do |form_name, class_name|
  @answered_forms ||= {}
  @answered_forms[form_name] = class_name
end

When("I navigate to my forms page") do
  visit("/my_forms")
end

Then("I should see a list of unanswered forms") do
  expect(page).to have_selector(".unanswered-forms-list")
end

Then("I should see the questions of {string}") do |form_name|
  expect(page).to have_selector(".form-questions")
  expect(page).to have_content(form_name)
end
