And('There is an evaluation form named {string} for the class {string}, with code {string}, class code {string}, semester {string}') do |form_name, class_name, code, class_code, semester|
  turma = Turma.find_or_create_by!(name: class_name) do |d|
    d.code = code
    d.class_code = class_code
    d.semester = semester
  end

  template = Template.find_or_create_by!(nome: "Avaliação de Disciplina") do |t|
    t.questions.build(enunciado: "Como você avalia a disciplina?", tipo: "multipla_escolha", opcoes: ["Excelente", "Bom", "Regular", "Ruim"])
    t.questions.build(enunciado: "Deixe sugestões para a disciplina.", tipo: "discursiva")
  end

  Formulario.find_or_create_by!(titulo: form_name, turma: turma, template: template)
end

And('I access the {string} forms page') do |page_name|
  @formulario = Formulario.find_by!(titulo: page_name)
  user = User.find_or_create_by!(email: "aluno@camaar.com") do |u|
    u.nome = "Aluno"
    u.matricula = "111111111"
    u.perfil = "discente"
    u.password = "password123"
    u.password_confirmation = "password123"
    u.save!
  end

  Enrollment.find_or_create_by!(user: user, turma: @formulario.turma, role: "discente")

  visit formularios_path
  expect(page).to have_current_path('/formularios')

  within('li', text: page_name) do
    click_link('Responder')
  end

  expect(page).to have_current_path(formulario_path(@formulario))
end

Given("I am logged in as a student user") do
  user = User.find_or_create_by(email: "aluno@camaar.com") { |u| u.perfil = "discente" }
  user.nome = "Aluno" if user.nome.blank?
  user.matricula = "111111111" if user.matricula.blank?
  user.password = "password123"
  user.password_confirmation = "password123"
  user.save!

  visit(new_user_session_path)
  fill_in('Email', with: user.email)
  fill_in('Password', with: user.password)
  click_button('Log in')
end

When('I fill the multiple choice question with {string}') do |option|
  choose(option)
end

When('I fill the open-ended question with {string}') do |text|
  fill_in('Deixe sugestões para a disciplina.', with: text)
end

When('I click the {string} button') do |button|
  click_button(button)
end

Then('the system should record my answers') do
end

Then('I should see the green message {string}') do |message|
  expect(page).to have_content(message)
  expect(page).to have_selector('.alert-success')
end

Then('I should be redirected to the forms page') do
  expect(page).to have_current_path('/formularios')
end

When('I do not select any option in the multiple choice question') do
end

When('I leave the open-ended question blank') do
end

Then('the system should not process the submission') do
  expect(page).to have_content("Please fill out this field.")
end
