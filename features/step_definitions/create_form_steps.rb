And("I select the class {string}") do |class_name|
  check("#{class_name}")
end

And("a class {string} exists") do |class_name|
  turma = Turma.find_or_create_by!(name: class_name) do |d|
    d.code = "ES101"
    d.class_code = "A"
    d.semester = "2026.1"
  end
end

And("I choose the template {string}") do |template_name|
  select(template_name, from: "Template")
end

And("I follow {string}") do |link|
  click_link(link)
end

Then("I should see the form creation page") do
  expect(page).to have_current_path('/formularios/new')
end

