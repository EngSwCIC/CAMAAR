def criar_formulario_para_resultados(name)
  template = Template.find_or_create_by!(nome: "Template #{name}") do |t|
    t.questions.build(enunciado: "Como você avalia a disciplina?", tipo: "discursiva")
  end

  turma = Turma.find_or_create_by!(code: "RES#{name.hash.abs % 1000}") do |t|
    t.name = name
    t.class_code = "TA"
    t.semester = "2026.1"
  end

  Formulario.find_or_create_by!(titulo: name, template: template, turma: turma)
end

Given("an answered form named {string} exists") do |name|
  @form_name = name
  @form_answered = true
  formulario = criar_formulario_para_resultados(name)

  aluno = User.find_or_create_by!(email: "resp_#{name.hash.abs % 10000}@unb.br") do |u|
    u.nome = "Respondente"
    u.matricula = "44444#{name.hash.abs % 1000}"
    u.perfil = "discente"
    u.password = "password123"
    u.password_confirmation = "password123"
  end

  formulario.questions.each do |question|
    Resposta.find_or_create_by!(formulario: formulario, user: aluno, question: question) do |r|
      r.valor = "Resposta de exemplo"
    end
  end
end

Given("a form with no answers named {string} exists") do |name|
  @form_name = name
  @form_answered = false
  criar_formulario_para_resultados(name)
end

And("I am on the results page of the form {string}") do |name|
  slug = name.downcase.tr(" .", "__").gsub(/[^a-z0-9_]/, "")
  visit("/resultados/#{slug}")
end

Then("the browser should start downloading the file {string}") do |filename|
  expect(page.response_headers["Content-Disposition"]).to include(filename)
end

And("the CSV file should contain the header with the form questions") do
  expect(page.body).to match(/pergunta/i)
end

And("the CSV file should contain one row per submitted answer") do
  expect(page.body.lines.count).to be > 1
end

And("no CSV file should be downloaded") do
  expect(page.response_headers["Content-Disposition"]).to be_nil
end
