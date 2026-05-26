When("I search for {string} in the search bar") do |search_term|
 
  fill_in "Search", with: search_term

  click_button "Search"
end

Then("I should see {string} in the list") do |expected_template|
  
  expect(page).to have_content(expected_template)  
end

And("I should not see {string} in the list") do |unexpected_template|
  
  expect(page).not_to have_content(unexpected_template)
end

Then("I should not see any templates in the list") do

  expect(page).not_to have_selector(".template-card")
end
