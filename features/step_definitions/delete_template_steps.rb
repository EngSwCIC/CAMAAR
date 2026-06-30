And("I check the checkbox to remove the template named {string}") do |template_name|
  within('li', text: template_name) do
    check('Remover')
  end
end

And("I do not check the checkbox to remove the template named {string}") do |template_name|
  within('li', text: template_name) do
    uncheck('Remover')
  end
end

And("I click the button {string} on the template named {string}") do |button_text, template_name|
  within('li', text: template_name) do
    click_button(button_text)
  end
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
