# Definições dos passos usados na feature do login

Given(/I am on the login page/) do
  visit logout_path
  page.should have_content("Entrar")
end

When(/I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in field, with: value
end

When(/I press "([^"]*)"$/) do |button|
  click_button button
end

Then(/I should see "([^"]*)"$/) do |message|
  expect(page).to have_content(message)
end