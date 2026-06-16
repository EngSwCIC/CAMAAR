Given("I am logged in as a participant user") do
  user = User.find_or_create_by(email: "aluno@camaar.com") { |u| u.perfil = "discente" }
  user.nome = "Aluno" if user.nome.blank?
  user.matricula = "111111111" if user.matricula.blank?
  user.password = "password123"
  user.password_confirmation = "password123"
  user.save!

  visit new_user_session_path
  fill_in "Email", with: user.email
  fill_in "Password", with: "password123"
  click_button "Log in"
end

And("I am enrolled in the class {string}") do |class_name|
  @enrolled_classes ||= []
  @enrolled_classes << class_name
end

And("I have already answered the form {string} for the class {string}") do |form_name, class_name|
  template = Template.find_or_create_by!(nome: "Template #{form_name}") do |record|
    record.descricao = "Template criado para o teste de visualização de formulários."
    record.questions.build(enunciado: "Como você avalia a disciplina?", tipo: "multipla_escolha", opcoes: ["Excelente", "Bom", "Regular", "Ruim"])
    record.questions.build(enunciado: "Deixe sugestões para a disciplina.", tipo: "discursiva")
  end

  turma = Turma.find_or_create_by!(name: class_name) do |d|
    d.code = "ES101"
    d.class_code = "A"
    d.semester = "2026.1"
  end

  form = Formulario.find_or_create_by!(titulo: form_name, template: template, turma: turma)

  user = User.find_or_create_by!(email: "aluno@camaar.com") do |u|
    u.nome = "Aluno"
    u.matricula = "111111111"
    u.password = "password123"
    u.password_confirmation = "password123"
    u.save!
  end

  Enrollment.find_or_create_by(user: user, turma: turma)

  for question in template.questions
    Resposta.create!(
      user: user,
      question: question,
      formulario: form
    ) 
  end
end

Then("I should see a list of unanswered forms") do
  expect(page).to have_content("Pendentes")
end

Then("I should see the questions of {string}") do |form_name|
  expect(page).to have_selector("#formulario_questoes")
end

And("the list should include {string} within {string}") do |form_name, section|
  within("##{section.downcase}") do
    expect(page).to have_content(form_name)
  end
end