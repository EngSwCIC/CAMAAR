When('I import data from SIGAA') do
  click_button 'flow-first-import-button'
end

Then(/^the (?:importing|importation|import operation) should be successful$/) do
  expect(page).to have_text('Dados importados com sucesso!')
end
