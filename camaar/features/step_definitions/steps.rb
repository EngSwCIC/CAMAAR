require "uri"
require "cgi"
require "i18n"
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))
I18n.config.available_locales = :en

def normalize_filename(filename)
  I18n.transliterate(filename).gsub(" ", "_").downcase
end

module WithinHelpers
  def with_scope(locator, &block)
    locator ? within(*selector_for(locator), &block) : yield
  end
end

World(WithinHelpers)

When(/^(.*) within (.*[^:])$/) do |step, parent|
  with_scope(parent) { When step }
end

When(/^(.*) within (.*[^:]):$/) do |step, parent, table_or_string|
  with_scope(parent) { When "#{step}:", table_or_string }
end

# Navigation
Given(/^(?:|I )am on the "(.+)" page$/) do |page_name|
  visit path_to(page_name)
end

When(/^(?:|I )go to the "(.+)" page$/) do |page_name|
  visit path_to(page_name)
end

When(/^(?:|I )follow "([^"]*)"$/) do |link|
  click_link(link)
end

When(/^(?:|I )follow "([^"]*)" at "([^"]*)"$/) do |link, email|
  open_email(email).click_link link
end

When(/I click on registration link at "([^"]*)"$/) do |email|
  UsersMailer.register_user(email).deliver_now
  open_email(email).click_link "Registrar"
end

Then(/^(?:|I )expect to be on the "([^"]*)" page$/) do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :expect
    current_path.expect == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then(/^show me the page$/) do
  save_and_open_page
end

# Buttons and clicks

When(/^(?:|I )press "([^"]*)"$/) do |button|
  click_link_or_button(button.downcase.gsub(" ", "_"))
end

When(/I click on "Confirmar"/) do
  click_button("Confirmar")
end

# Forms and templates

And(/^(?:|I )fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field.downcase.gsub(" ", "_"), with: value, match: :prefer_exact, visible: :all)
end

And(/^(?:|I )fill in "([^"]*)" for "([^"]*)"$/) do |value, field|
  fill_in(field, with: value)
end

When(/^(?:|I )fill in the following:$/) do |fields|
  fields.rows_hash.each do |field, value|
    fill_in(field.downcase.gsub(" ", "_"), with: value, match: :prefer_exact, visible: :all)
  end
end

When(/^(?:|I )select "([^"]*)" from "([^"]*)"$/) do |value, field|
  select(value, from: field.gsub(" ", "_").downcase, visible: :all)
end

When(/^(?:|I )check "([^"]*)"$/) do |field|
  check(field)
end

When(/^(?:|I )uncheck "([^"]*)"$/) do |field|
  uncheck(field)
end

When(/^(?:|I )choose "([^"]*)"$/) do |field|
  choose(field.downcase.gsub(" ", "_"))
end

When(/^(?:|I )attach the file "([^"]*)" to "([^"]*)"$/) do |path, field|
  attach_file(field, File.expand_path(path))
end

# Database and examples
Given("I am an authenticated User") do
  FactoryBot.create(:user, :user1)
end

Given('I am an authenticated User from class "BANCOS DE DADOS"') do
  FactoryBot.create(:user, :user4)
end

Given(/I ended my session/) do
  click_link_or_button("Sair")
end

Given(/I am an authenticated (Teacher|Student) associated with the following classes:$/) do |role, fields|
  visit("/users/login")
  classes = fields.hashes

  if role == "Student"
    User.create!(id: 8, email: "peluticaio@gmail.com", password: "abc123", password_confirmation: "abc123", created_at: Time.now.utc, updated_at: Time.now.utc, confirmed_at: Time.now.utc)
    student = Student.find_by(email: "peluticaio@gmail.com")
    classes.each do |sbj|
      sbj_class = SubjectClass.find_by({ subject: sbj["subject"], code: sbj["code"], semester: sbj["semester"] })
      Enrollment.create(student_id: student.id, subject_class_id: sbj_class.id)
    end

    fill_in("email", with: "peluticaio@gmail.com")
    fill_in("password", with: "abc123")
    click_button("Confirmar")
  else
    teacher = Teacher.find_by(email: "mholanda@unb.br")
    User.create(id: 1, email: "mholanda@unb.br", password: "abc123", password_confirmation: "abc123", created_at: Time.now.utc, updated_at: Time.now.utc, confirmed_at: Time.now.utc)
    classes.each do |sbj|
      sbj_class = SubjectClass.find_by(subject: sbj["subject"], code: sbj["code"], semester: sbj["semester"])
      sbj_class.update(teacher_id: teacher.id)
    end

    fill_in("email", with: "mholanda@unb.br")
    fill_in("password", with: "abc123")
    click_button("Confirmar")
  end
end

Given(/I am an authenticated Coordinator from the "([^"]*)"$/) do |dpt_name|
  department = Department.find_by({ name: dpt_name })
  coordinator = Coordinator.find_by({ department_id: department.id })

  visit("/admins/login")
  # puts page.body
  fill_in("email", with: coordinator.email)
  fill_in("password", with: "admin123")
  click_button("Confirmar")
end

Given(/that I imported classes for "DEPTO CIÊNCIAS DA COMPUTAÇÃO"/) do
  classes = SubjectClass.find_by({ department_id: 508 })
  unless classes
    classes = JSON.parse(File.read("./db/classes.json"))
    classes.each do |subject_class|
      initials = subject_class["code"].gsub(/[^a-zA-Z]/, "")
      SubjectClass.create!(
        {
          subject: subject_class["code"],
          name: subject_class["name"],
          code: subject_class["class"]["classCode"],
          semester: subject_class["class"]["semester"],
          schedule: subject_class["class"]["time"],
          department_id: Department.find_by(initials:).id,
        }
      )
    end
  end
end

When(/I press on "Importar"/) do
  click_button("Importar")
end

Given "I am not enrolled in any class" do
  Enrollment.destroy_all
end

Given(/that I am a registered User/) do # if user or admin
  User.create!({
                 email: "mholanda@unb.br",
                 password: "professor123",
                 password_confirmation: "professor123",
                 confirmed_at: Time.now.utc,
               })
end

Given(/that I am a registered Admin/) do # if user or admin
  admin = Admin.find_by({ email: "admin.dex@gmail.com" })
  # visit('/admins/login')
  # fill_in('email', with: admin.email)
  # fill_in('password', with: 'admin123')
  # click_button('Confirmar')
end

Given(/that I am an unregistered ([^"]*)$/) do |_role|
  User.find_by({ email: "noexists@gmail.com" }) == 0
end

And(/there are no emails/) do
  clear_emails
end

Given(/I have no emails at "([^"]*)"$/) do |email|
  open_email(email)
  expect(all_emails).to be_empty
end

And(/I received a ([^"]*) email at "([^"]*)"$/) do |_email_type, email| # reset or registration
  open_email(email)
  current_email == _email_type
end

Given(/that I imported ([^"]*) for the "([^"]*)"$/) do |_datatype, _dpt_name|
  pending
end

Given(/that the department "([^"]*)" has no classes$/) do |dpt_name|
  department = Department.find_by(name: dpt_name)

  SubjectClass.where(department_id: department.id).each do |sbj|
    sbj.destroy!
  end
end

Given(/^that a form has been assigned to the (students|teachers) of the following classes:$/) do |role, fields|
  step 'I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"'

  if role == "teachers"
    fields.hashes.each do |form|
      step 'that I created the teacher template "Formulário Professor"'

      step 'I follow "Envio"'
      step 'I expect to be on the "Dispatch" page'
      step 'I expect to see "Opções para Envio"'

      step 'I select "Formulário Professor" from "Teacher template"'
      step 'I expect to see "Formulário Professor"'

      step %'I check "#{form["semester"]}_#{form["subject"]}_#{form["code"]}"'
      step 'I press "Confirm"'
      step 'I expect to see "O formulário para o professor da turma BANCOS DE DADOS foi criado com sucesso."'

      step "I ended my session"
    end
  else
    fields.hashes.each do |form|
      step 'that I created the student template "Formulário Aluno"'

      step 'I follow "Envio"'
      step 'I expect to be on the "Dispatch" page'
      step 'I expect to see "Opções para Envio"'

      step 'I select "Formulário Aluno" from "Student template"'
      step 'I expect to see "Formulário Aluno"'

      step %'I check "#{form["semester"]}_#{form["subject"]}_#{form["code"]}"'
      step 'I press "Confirm"'
      step 'I expect to see "O formulário para os alunos da turma BANCOS DE DADOS foi criado com sucesso."'

      step "I ended my session"
    end
  end
end

Given("that I am an User associated with the following classes:") do |_table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending
end

Then (/I expect the student "([^"]*)" to not be associated with following classes:/) do |name, table|
  classes = table.hashes
  student = Student.find_by(name: name)
  classes.each do |data|
    subject_class = SubjectClass.find_by(semester: data["semester"], code: data["code"], subject: data["subject"])
    enrollment = Enrollment.find_by(student_id: student.id, subject_class_id: subject_class.id)
    expect(enrollment).to be_nil
  end
end

Then("I expect to see the following classes:") do |table|
  expected_classes = table.hashes

  expected_classes.each do |subject_class|
    text = "#{subject_class["semester"]} - #{subject_class["name"]} - #{subject_class["code"]}"
    expect(page).to have_text(text)
  end
end

Given("that I have not answered any form") do
  pending
end

Given (/that I answered the "([^"]*)" form/) do |form|
  step 'I expect to be on the "Forms" page'
  step 'I follow "Pendentes"'

  step %'I expect to see "#{form}"'
  step %'I follow "#{form}"'
  step %'I expect to be on the "#{form}" page'

  step "I expect to see the following:", table(%(
            | name                       |
            | #{form}         |
            | Classifique seu rendimento |
            | Dê uma sugestão            |))

  step 'I choose "Question 1 Option 1"'
  step 'I fill in "Question 2" with "Resposta"'
  step 'I press "Submit"'

  step 'I follow "Respondidos"'
  step 'I expect to be on the "Forms" page'
  step %'I expect to see "#{form}"'
end

Given(/that a form assigned to the (students|teachers) of the following classes were answered:/) do |role, table|
  classes = table.hashes
  if role == "students"
    classes.each do |data|
      step "that a form has been assigned to the students of the following classes:", table(%(
            | subject | semester | code |
            | #{data["subject"]} | #{data["semester"]}   | #{data["code"]}   |))

      step "I am an authenticated Student associated with the following classes:", table(%(
            | subject | semester | code |
            | #{data["subject"]} | #{data["semester"]}   | #{data["code"]}   |))

      step 'that I answered the "Formulário Aluno" form'
      step "I ended my session"
    end
  else
  end
end

Then(/I expect to see a download window with the file "([^"]*)"/) do |expected_filename|
  actual_filename = page.response_headers["Content-Disposition"]
  actual_filename.should include(normalize_filename(expected_filename))
end

Given(/that the student "([^"]*)" has left the following classes:/) do |name, table|
  data = table.hashes

  student = Student.find_by(name: name)
  data.each do |sbj|
    subject_class = SubjectClass.find_by(subject: sbj["subject"], code: sbj["code"], semester: sbj["semester"])

    Enrollment.find_by(subject_class_id: subject_class.id, student_id: student.id).destroy
  end
end

Given("that the classes were updated with the following:") do |table|
  data = table.hashes
  data.each do |sbj|
    new_data = { name: sbj["name"], schedule: sbj["schedule"] }
    class_key = { subject: sbj["subject"], code: sbj["code"], semester: sbj["semester"] }
    SubjectClass.find_by(class_key).update(new_data)
  end
end

When(/^(?:|I )create a "([^"]*)" question with the following:$/) do |question_type, fields|
  step 'I press "Add Question"'
  step 'I expect to be on the "Add Question" page'
  step %(I select "#{question_type}" from "question type")

  case question_type
  when "Múltipla escolha"
    options_count = fields.rows.size
    step %(I select "#{options_count}" from "options number")
  end

  fields.rows_hash.each do |field, value|
    step %(I fill in "#{field}" with "#{value}")
  end

  step 'I press "Add"'
  step 'I expect to be on the "New Template" page'
end

Given(/^that I created the (teacher|student) template "([^"]*)"$/) do |template_type, template_name|
  step 'I am on the "Templates" page'
  step 'I press "Add template"'
  step 'I expect to be on the "New Template" page'

  step 'I create a "Múltipla escolha" question with the following:', table(%(
            | title   | Classifique seu rendimento |
            | option1 | Ótimo                      |
            | option2 | Bom                        |
            | option3 | Médio                      |
            | option4 | Ruim                       |
            | option5 | Péssimo                    |))
  step 'I create a "Texto" question with the following:', table(%(
    | title | Dê uma sugestão |
  ))

  step "I fill in \"Name\" with \"#{template_name}\""
  if template_type == "teacher"
    step 'I select "Docente" from "Template role"'
  else
    step 'I select "Discente" from "Template role"'
  end
  step 'I press "Save"'
  step 'I expect to be on the "Templates" page'
  step "I expect to see \"#{template_name}\""
end

Given(/^that "([^"]*)" was deleted$/) do |template_name|
  Template.destroy(template_name.scan(/\d+/).first.to_i)
end

# Visualization

Then(/^(?:|I )expect to see "([^"]*)"$/) do |text|
  if page.respond_to? :expect
    page.expect have_content(text)
  elsif page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then(/^(?:|I )expect to see the following:$/) do |fields|
  fields.raw[1..-1].flatten.each do |text|
    if page.respond_to? :expect
      page.should have_content(text)
    else
      assert page.has_content?(text)
    end
  end
end

Then(/^(?:|I )expect to not see "([^"]*)"$/) do |text|
  if page.respond_to? :should
    page.should have_no_content(text)
  else
    assert page.has_no_content?(text)
  end
end

Then(/^(?:|I )expect "([^"]*)" to be checked$/) do |field|
  input_id = field.downcase.gsub(" ", "_")
  expect(find("##{input_id}", visible: :all)).to be_checked
end

Then(/I expect to only see classes starting with "([^"]*)"/) do |initials|
  # Locate the table rows
  rows = find("table.table.table-borderless.table-data3 tbody").all("tr")

  # Iterate through the rows and check if the class names start with the initials
  rows.each do |row|
    class_name = row.find("td:nth-child(3)").text
    expect(class_name).to start_with(initials)
  end
end

Then(/I expect to see the button "([^"]*)"$/) do |button|
  expect(page).to have_button(id: button.gsub(" ", "_").downcase)
end

Then(/I expect to see the following forms as ([^"]*):$/) do |_status, _table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending
end

Given ("that no templates have been created") do
  Template.destroy_all
  visit templates_path
end

Then("I expect to see the following templates:") do |_table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending
end

Then("I expect to see the following table:") do |table|
  expected_table = table.raw

  actual_table = find("table")

  actual_table_data = actual_table.all("tr").map do |row|
    row.all("th, td").map(&:text)
  end

  expect(actual_table_data).to eq(expected_table)
end

Then("I expect to see the following results:") do |_table|
  pending
end

# Field verification
Then(/^the "([^"]*)" field(?: within (.*))? should contain "([^"]*)"$/) do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = field.tag_name == "textarea" ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

Then(/^the "([^"]*)" field(?: within (.*))? should not contain "([^"]*)"$/) do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = field.tag_name == "textarea" ? field.text : field.value
    if field_value.respond_to? :should_not
      field_value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, field_value)
    end
  end
end

Then(/^the "([^"]*)" field should have the error "([^"]*)"$/) do |field, error_message|
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
  elsif using_formtastic
    error_paragraph = element.find(:xpath, '../*[@class="inline-errors"][1]')
    assert error_paragraph.has_content?(error_message)
  else
    assert page.has_content?("#{field.titlecase} #{error_message}")
  end
end

Then(/^the "([^"]*)" field should have no error$/) do |field|
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

Then(/^the "([^"]*)" checkbox(?: within (.*))? should be checked$/) do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)["checked"]
    if field_checked.respond_to? :should
      field_checked.should be_true
    else
      assert field_checked
    end
  end
end

Then(/^the "([^"]*)" checkbox(?: within (.*))? should not be checked$/) do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)["checked"]
    if field_checked.respond_to? :should
      field_checked.should be_false
    else
      assert !field_checked
    end
  end
end

Then(/^(?:|I )should have the following query string:$/) do |expected_pairs|
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
Then("I should download be able to export a {string} file with all the answers") do |_string|
  pending
end

Then("I should be able to see the answered form as a chart") do
  pending
end

When(/I import a "([^"]*)" file with the ([^"]*) data$/) do |_filetype, _datatype|
  pending
end

# When(/When I select "Membros" from "Tipos de dados"/) do
#   select(value, from: "select-data", visible: :all)
# end
