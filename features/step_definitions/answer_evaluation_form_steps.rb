Given('I have already accessed the form page for the subject {string}') do |subject|
  visit "/avaliacoes/responder/#{subject.downcase.tr(' ', '_')}"
end

When('I fill the multiple choice question with {string}') do |option|
  choose option
end

When('I fill the open-ended question with {string}') do |text|
  fill_in 'Questão Discursiva', with: text
end

When('I click the {string} button') do |button|
  click_button button
end

Then('the system should record my answers') do
end

Then('I should be redirected to the class list') do
  expect(page).to have_current_path('/turmas')
end

Then('I should see the green message {string}') do |message|
  expect(page).to have_content(message)
  expect(page).to have_selector('.alert-success')
end

When('I do not select any option in the multiple choice question') do
end

When('I leave the open-ended question blank') do
  fill_in 'Questão Discursiva', with: ''
end

Then('the system should not process the submission') do
  expect(page).to have_button('Submit Evaluation')
end

Then('I should see the alert {string}') do |message|
  expect(page).to have_content(message)
  expect(page).to have_selector('.alert-danger')
end
