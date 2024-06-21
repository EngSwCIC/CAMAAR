When('I send forms') do
  Rails.application.load_seed
  step 'I am on the Send page'

  checkboxes_exist = false
  checkboxes_to_select = []

  (1..10).each do |id|
    if page.has_css?("#discipline_ids_#{id}")
      checkboxes_exist = true
      checkboxes_to_select << id
    end
  end

  raise 'No checkboxes found' unless checkboxes_exist

  # Randomly check one
  checkboxes_to_select.sample(1).each do |id|
    check("discipline_ids_#{id}")
  end
  puts Template.all.inspect

  click_button(:commit)
end

When('I send forms wihout checking any classes') do
  step 'I am on the Send page'
  pending 'TODO: Controller should handle nil discipline_ids'
  click_button(:commit)
end

Then('the forms should have been sent') do
  step 'I should be on the Management page'
  expect(page).to have_text('Formulários enviados com sucesso')
end

Given(/^(?:I|an administrator) sent (?:out )?forms to students$/) do
  step 'I send forms'
end
