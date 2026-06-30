Given("I have created a form called {string}") do |form_name|
  template = Template.find_or_create_by!(nome: "Template #{form_name}") do |record|
    record.descricao = "Template criado para o teste de visualização de formulários."
    record.questions.build(enunciado: "Pergunta de múltipla escolha?", tipo: "multipla_escolha", opcoes: [ "Opção 1", "Opção 2", "Opção 3" ])
    record.questions.build(enunciado: "Pergunta discursiva?", tipo: "discursiva")
  end

  turma = Turma.find_or_create_by!(name: "Turma 1") do |d|
    d.code = "ES101"
    d.class_code = "A"
    d.semester = "2026.1"
  end

  Formulario.find_or_create_by!(titulo: form_name, template: template, turma: turma)
end

When("I navigate to the forms page") do
  click_link("Formulários")
end

Then("I should see a list of created forms") do
  expect(page).to have_content("Formulários")
end

And("I click on the form named {string}") do |form_name|
  within('li', text: form_name) do
    click_link("#{form_name}")
  end
end

Then("I should see the message {string}") do |message|
  expect(page).to have_content(message)
end

Then("I should see the responses of {string}") do |form_name|
  expect(page).to have_content("Resultados — #{form_name}")
end
