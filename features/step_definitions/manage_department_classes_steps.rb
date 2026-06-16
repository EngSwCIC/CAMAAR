Given("I am logged in as an admin user from the department {string}") do |department|
  @admin_department = department
  user = User.find_or_create_by(email: "admin@camaar.com") do |u|
    u.perfil = "docente"
    #u.department = department
  end
  visit(new_user_session_path)
  fill_in('Email', with: user.email)
  fill_in('Password', with: 'password123')
  click_button('Log in')
end

And("the current semester is {string}") do |semester|
  @current_semester = semester
end

And("the following classes exist:") do |table|
  @classes = table.hashes
  @classes.each do |row|
    Turma.find_or_create_by(code: row["code"]) do |k|
      k.name = row["name"]
      k.department = row["department"]
      k.semester = row["semester"]
    end
  end
end

When("I navigate to the classes management page") do
  visit("/classes")
end

Then("I should see the class {string}") do |class_label|
  expect(page).to have_content(class_label)
end

And("I should not see the class {string}") do |class_label|
  expect(page).not_to have_content(class_label)
end

Then("I should see only classes from semester {string}") do |semester|
  expect(page).to have_selector(".class-row[data-semester='#{semester}']")
  expect(page).not_to have_selector(".class-row:not([data-semester='#{semester}'])")
end

And("each listed class should belong to {string}") do |department|
  page.all(".class-row").each do |row|
    expect(row["data-department"]).to eq(department)
  end
end

And("I click on the class {string}") do |class_label|
  click_link(class_label)
end

And("I should see the list of enrolled students") do
  expect(page).to have_selector(".enrolled-students")
end

And("I should see the assigned professor") do
  expect(page).to have_selector(".assigned-professor")
end

And("I click on {string} for the class {string}") do |action, class_label|
  within(".class-row", text: class_label) { click_on(action) }
end

And("I update the professor to {string}") do |professor|
  fill_in("Professor", with: professor)
end

And("the class {string} should have professor {string}") do |class_label, professor|
  within(".class-row", text: class_label) do
    expect(page).to have_content(professor)
  end
end

And("I click on {string}") do |button|
  click_button(button)
end

When("I try to access the management page of the class {string}") do |code|
  visit("/classes/#{code}")
end

And("I should be redirected to the classes management page") do
  expect(page).to have_current_path("/classes")
end

Given("the department {string} has no classes in semester {string}") do |department, semester|
  Turma.where(department: department, semester: semester).destroy_all
end
