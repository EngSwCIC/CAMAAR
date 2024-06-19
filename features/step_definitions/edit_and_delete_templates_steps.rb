Then('the already created forms should not be affected') do
  expect(page).to have_content('Existing Form 1')
  expect(page).to have_content('Existing Form 2')
end

Then('the template should be deleted successfully') do
  expect(page).to have_content('Template deleted successfully')
end

Then('the template should not be updated') do
  expect(page).to have_content('Error updating template')
end
