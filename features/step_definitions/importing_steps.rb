When('I click the "import" button') do
  click_button 'flow-first-import-button'
end

Given(/^(?:I|an administrator) imported data from SIGAA$/) do
  step 'I am logged in as an administrator'
  step 'I am on the Management page'
  step 'I click the "import" button'
end

Then(/^the (?:importing|importation|import operation) should be successful$/) do
  expect(page).to have_text('Dados importados com sucesso!')
end
