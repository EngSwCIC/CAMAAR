require "uri"
require "cgi"

require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end

World(WithinHelpers)

When (/^(.*) within (.*[^:])$/) do |step, parent|
  with_scope(parent) { When step }
end

When (/^(.*) within (.*[^:]):$/) do |step, parent, table_or_string|
  with_scope(parent) { When "#{step}:", table_or_string }
end

# Navigation
Given (/^(?:|I )am on the "(.+)" page$/) do |page_name|
  visit path_to(page_name)
end

When (/^(?:|I )go to the "(.+)" page$/) do |page_name|
  visit path_to(page_name)
end

When (/^(?:|I )follow "([^"]*)"$/) do |link|
  click_link(link)
end

Then (/^(?:|I )expect to be on the "([^"]*)" page$/) do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :expect
    current_path.expect == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then (/^show me the page$/) do
  save_and_open_page
end

# Buttons and clicks
When (/^(?:|I )press "([^"]*)"$/) do |button|
  click_button(button)
end

And (/^(?:|I )confirm a popup$/) do
  accept_confirm do
    click_button("OK")
  end
end

And (/^(?:|I )dismiss a popup$/) do
  dismiss_confirm do
    click_button("Cancel")
  end
end

# Forms and templates
And (/^(?:|I )fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  puts field.downcase.gsub(" ", "_")
  fill_in(field.downcase.gsub(" ", "_"), with: value, match: :prefer_exact)
end

And (/^(?:|I )fill in "([^"]*)" for "([^"]*)"$/) do |value, field|
  fill_in(field, with: value)
end

When (/^(?:|I )fill in the following:$/) do |fields|
  fields.rows_hash.each do |name, value|
    When %{I fill in "#{name}" with "#{value}"}
  end
end

When (/^(?:|I )select "([^"]*)" from "([^"]*)"$/) do |value, field|
  select(value, :from => field)
end

When (/^(?:|I )check "([^"]*)"$/) do |field|
  check(field)
end

When (/^(?:|I )uncheck "([^"]*)"$/) do |field|
  uncheck(field)
end

When (/^(?:|I )choose "([^"]*)"$/) do |field|
  choose(field)
end

When (/^(?:|I )attach the file "([^"]*)" to "([^"]*)"$/) do |path, field|
  attach_file(field, File.expand_path(path))
end

Then(/^(?:|I )create question (\d+) as a (multiple choice|text) question:$/) do |number, type|
  pending
end

# Database and examples
Given("I am an authenticated User") do
  pending
end

Given (/I am an authenticated Coordinator from the "([^"]*)"$/) do |dpt_name|
  department = Department.find_by({ name: dpt_name })
  coordinator = Coordinator.find_by({ department_id: department.id })

  visit("/admins/login")
  fill_in("email", :with => coordinator.email)
  fill_in("password", :with => "admin123")
  click_button("Confirmar")
end

Given(/that I created the following templates:$/) do |table|
  pending
end

Given(/that I am a registered ([^"]*)$/) do |role| #if user or admin
  pending
end

Given(/that I am an unregistered ([^"]*)$/) do |role|
  pending # Write code here that turns the phrase above into concrete actions
end

And (/I received a ([^"]*) email at "([^"]*)"$/) do |email_type| #reset or registration
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/that I imported ([^"]*) for the "([^"]*)"$/) do |datatype, dpt_name|
  pending # Write code here that turns the phrase above into concrete actions
end

Given("that a form has been assigned to the following classes:") do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Given("that I am an User associated with the following classes:") do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Given("that I have not answered any form") do
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/that I have answered the following forms:$/) do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/that the "([^"]*)" form has been answered/) do |form_name|
  pending # Write code here that turns the phrase above into concrete actions
end

Given("that the student {string} has left the class {string}") do |string, string2|
  pending # Write code here that turns the phrase above into concrete actions
end

Given("that the class {string} was updated with:") do |string, table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

# Visualization
Then (/^(?:|I )should see "([^"]*)"$/) do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then (/^(?:|I )should see the following:$/) do |fields|
  fields.rows_hash.each do |text|
    Then %{I should see "#{name}"}
  end
end

Then (/^(?:|I )should see \/([^\/]*)\/$/) do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath("//*", :text => regexp)
  else
    assert page.has_xpath?("//*", :text => regexp)
  end
end

Then (/^(?:|I )should not see "([^"]*)"$/) do |text|
  if page.respond_to? :should
    page.should have_no_content(text)
  else
    assert page.has_no_content?(text)
  end
end

Then (/^(?:|I )should not see \/([^\/]*)\/$/) do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_no_xpath("//*", :text => regexp)
  else
    assert page.has_no_xpath?("//*", :text => regexp)
  end
end

And ("I should only see classes starting with {string}") do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/I should see the button "([^"]*)" on "([^"]*)"$/) do |button, element|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/I should see the following forms as ([^"]*):$/) do |status, table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

And("I should see the following classes:") do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should see the following templates:") do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should see the following results:") do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

# Field verification
Then (/^the "([^"]*)" field(?: within (.*))? should contain "([^"]*)"$/) do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == "textarea") ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

Then (/^the "([^"]*)" field(?: within (.*))? should not contain "([^"]*)"$/) do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == "textarea") ? field.text : field.value
    if field_value.respond_to? :should_not
      field_value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, field_value)
    end
  end
end

Then (/^the "([^"]*)" field should have the error "([^"]*)"$/) do |field, error_message|
  element = find_field(field)
  classes = element.find(:xpath, "..")[:class].split(" ")

  form_for_input = element.find(:xpath, "ancestor::form[1]")
  using_formtastic = form_for_input[:class].include?("formtastic")
  error_class = using_formtastic ? "error" : "field_with_errors"

  if classes.respond_to? :should
    classes.should include(error_class)
  else
    assert classes.include?(error_class)
  end

  if page.respond_to?(:should)
    if using_formtastic
      error_paragraph = element.find(:xpath, '../*[@class="inline-errors"][1]')
      error_paragraph.should have_content(error_message)
    else
      page.should have_content("#{field.titlecase} #{error_message}")
    end
  else
    if using_formtastic
      error_paragraph = element.find(:xpath, '../*[@class="inline-errors"][1]')
      assert error_paragraph.has_content?(error_message)
    else
      assert page.has_content?("#{field.titlecase} #{error_message}")
    end
  end
end

Then (/^the "([^"]*)" field should have no error$/) do |field|
  element = find_field(field)
  classes = element.find(:xpath, "..")[:class].split(" ")
  if classes.respond_to? :should
    classes.should_not include("field_with_errors")
    classes.should_not include("error")
  else
    assert !classes.include?("field_with_errors")
    assert !classes.include?("error")
  end
end

Then (/^the "([^"]*)" checkbox(?: within (.*))? should be checked$/) do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)["checked"]
    if field_checked.respond_to? :should
      field_checked.should be_true
    else
      assert field_checked
    end
  end
end

Then (/^the "([^"]*)" checkbox(?: within (.*))? should not be checked$/) do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)["checked"]
    if field_checked.respond_to? :should
      field_checked.should be_false
    else
      assert !field_checked
    end
  end
end

Then (/^(?:|I )should have the following query string:$/) do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair { |k, v| expected_params[k] = v.split(",") }

  if actual_params.respond_to? :should
    actual_params.should == expected_params
  else
    assert_equal expected_params, actual_params
  end
end

# Import and export
Then("I should download be able to export a {string} file with all the answers") do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should be able to see the answered form as a chart") do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/I import a "([^"]*)" file with the ([^"]*) data$/) do |filetype, datatype|
  pending # Write code here that turns the phrase above into concrete actions
end
