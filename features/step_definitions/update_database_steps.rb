Given("a valid SIGAA data file is available") do
  @sigaa_file = Rails.root.join("spec/fixtures/sigaa_valid.json")
end

Given("an invalid SIGAA data file is available") do
  @sigaa_file = Rails.root.join("spec/fixtures/sigaa_invalid.json")
end

When("I navigate to the admin import page") do
  visit("/admin/import")
end

And("I upload the SIGAA data file") do
  attach_file("sigaa_file", @sigaa_file)
end

And("the system data should reflect the new SIGAA information") do
  expect(page).to have_content("Dados atualizados")
end

And("the template {string} should still exist") do |template_name|
  visit("/templates")
  expect(page).to have_content(template_name)
end

And("the form {string} should still exist") do |form_name|
  visit("/forms")
  expect(page).to have_content(form_name)
end

And("the database should remain unchanged") do
  expect(Klass.count).to eq(@classes ? @classes.size : Klass.count)
end
