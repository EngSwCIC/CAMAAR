And("I confirm the deletion") do
  page.driver.browser.switch_to.alert.accept rescue click_on("Confirm")
end

And("I cancel the deletion") do
  page.driver.browser.switch_to.alert.dismiss rescue click_on("Cancel")
end

And("the list should not include {string}") do |item_name|
  expect(page).not_to have_content(item_name)
end

Given("I have created a form from the template {string}") do |template_name|
  @template_form = template_name
end

And("the form created from {string} should still exist") do |template_name|
  visit("/forms")
  expect(page).to have_content(template_name)
end
