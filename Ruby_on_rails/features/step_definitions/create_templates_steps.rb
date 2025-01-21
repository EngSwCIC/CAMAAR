Given('I am on the template page') do
    visit template_path
  end
  
  When('I press "+"') do
    click_button '+'
  end
  
  Then('I should go to the create template page') do
    visit create_template_path
  end
  
  When('I fill in the {string} field with {string}') do |field, value|
    fill_in field, with: value
  end
  
  When('I press {string}') do |button_text|
    click_button button_text
  end
  
  Then('I should go to the template page') do
    visit template_path
  end
  
  Then('I should see {string}') do |template_name|
    expect(page).to have_content(template_name)
  end

  Then('I should remain on the create template page') do
    expect(page).to have_current_path(create_template_path)
  end
  
  Then('I should see the error message {string}') do |error_message|
    expect(page).to have_content(error_message)
  end
  