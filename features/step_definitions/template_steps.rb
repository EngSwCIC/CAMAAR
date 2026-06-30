Given("I am logged in as an admin user") do
  admin = User.find_or_initialize_by(email: "admin@camaar.com")
  admin.nome = "Administrador" if admin.nome.blank?
  admin.matricula = "000000000" if admin.matricula.blank?
  admin.perfil = "docente"
  admin.password = "password123"
  admin.password_confirmation = "password123"
  admin.save!

  visit(new_user_session_path)
  fill_in('Email', with: admin.email)
  fill_in('Password', with: 'password123')
  click_button('Log in')
end

Given("I have created a template with the name Avaliação de Disciplina") do
  template = Template.find_or_create_by!(nome: "Avaliação de Disciplina") do |t|
    t.questions.build(enunciado: "Como você avalia a disciplina?", tipo: "multipla_escolha", opcoes: [ "Excelente", "Bom", "Regular", "Ruim" ])
    t.questions.build(enunciado: "Deixe sugestões para a disciplina.", tipo: "discursiva")
  end
  template.save!
end

Given("I have created a template with the name Avaliação de Docente") do
  template = Template.find_or_create_by!(nome: "Avaliação de Docente") do |t|
    t.questions.build(enunciado: "Como você avalia o docente?", tipo: "multipla_escolha", opcoes: [ "Excelente", "Bom", "Regular", "Ruim" ])
    t.questions.build(enunciado: "Deixe sugestões para o docente.", tipo: "discursiva")
  end
  template.save!
end

Given("I have created a template with the name {string}") do |template_name|
  template = Template.find_or_create_by!(nome: template_name) do |t|
    t.questions.build(enunciado: "Question 1", tipo: "multipla_escolha", opcoes: [ "Option 1", "Option 2", "Option 3" ])
    t.questions.build(enunciado: "Question 2", tipo: "discursiva")
  end
  template.save!
end

And("I am on the dashboard page") do
  visit("/")
end

And("the list should include {string}") do |template_name|
  expect(page).to have_content(template_name)
end

And("I click on the template named {string}") do |template_name|
  click_link(template_name)
end

And("the details should include the name {string}") do |template_name|
  expect(page).to have_content(template_name)
end

And("I click {string} on the template named {string}") do |button_text, template_name|
  within('li', text: template_name) do
    click_link(button_text)
  end
end

When("I navigate to the templates page") do
  visit("/templates")
end

Then("I should see a list of created templates") do
  expect(page).to have_content("Templates")
end

Then("I should see the details of {string}") do |template_name|
  expect(page).to have_content(template_name)
end
