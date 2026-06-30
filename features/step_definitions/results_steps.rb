Given("I am logged in as {string}") do |user_email|
  email = user_email.include?("@") ? user_email : "#{user_email}@camaar.com"
  user = User.find_or_initialize_by(email: email)
  user.nome = "Administrador" if user.nome.blank?
  user.matricula = "000000002" if user.matricula.blank?
  user.perfil = "docente"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.save!

  visit(new_user_session_path)
  fill_in("Email", with: user.email)
  fill_in("Password", with: "password123")
  click_button("Log in")
end

Given("I am on the {string} page") do |page|
  visit(send("#{page.downcase}_path"))
end

Given("I click on the {string} form") do |form_name|
  unless Formulario.exists?(titulo: form_name)
    template = Template.find_or_create_by!(nome: "Template #{form_name}") do |t|
      t.questions.build(enunciado: "Pergunta?", tipo: "discursiva")
    end
    turma = Turma.find_or_create_by!(code: "RV#{form_name.hash.abs % 1000}") do |t|
      t.name = form_name
      t.class_code = "TA"
      t.semester = "2026.1"
    end
    Formulario.find_or_create_by!(titulo: form_name, template: template, turma: turma)
  end
  visit(formularios_path)
  click_link(form_name)
end

Then("I should see the results for the {string} form") do |form_name|
  expect(page).to have_content("Results for #{form_name}")
end

Then("I should see a message indicating that there are no results for the {string} form") do |form_name|
  expect(page).to have_content("No results available for #{form_name}")
end
