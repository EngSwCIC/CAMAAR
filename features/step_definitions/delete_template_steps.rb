And("I confirm the deletion") do
  page.driver.browser.switch_to.alert.accept rescue click_on("OK")
end

And("I cancel the deletion") do
  page.driver.browser.switch_to.alert.dismiss rescue click_on("Cancelar")
end

And("the list should not include {string} within {string}") do |item_name, list_name|
  within("##{list_name.downcase}") do
    expect(page).not_to have_content(item_name)
  end
end

Given("I have created a form from the template {string}") do |template_name|
  @template_form = template_name
end

And("the form created from {string} should still exist") do |template_name|
  visit("/formularios")
  expect(page).to have_content(template_name)
end
