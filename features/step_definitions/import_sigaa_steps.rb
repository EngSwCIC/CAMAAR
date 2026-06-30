And("the system database is empty") do
  Enrollment.destroy_all if defined?(Enrollment)
  Turma.destroy_all if defined?(Turma)
  User.where.not(perfil: "docente").destroy_all if defined?(User)
end

And("I navigate to the {string} page") do |page|
  paths = {
    "Importação SIGAA" => "/users/new"
  }
  visit(paths[page] || "/users/#{page.downcase.tr(' ', '_')}")
end

Given("a valid SIGAA file with classes, subjects and participants is available") do
  @sigaa_file = Rails.root.join("db/amostra_sigaa.csv")
end

When("I upload the SIGAA import file") do
  attach_file("file", @sigaa_file)
end

Then("the system should create the classes in the database") do
  expect(Turma.count).to be > 0
end

And("the system should create the subjects in the database") do
  expect(Enrollment.count).to be > 0
end

And("the system should create the participants in the database") do
  expect(User.where.not(perfil: "docente").count).to be > 0
end

Given("the class {string} already exists in the system") do |code|
  Turma.find_or_create_by(code: code, class_code: "TA", semester: "2026.1") do |turma|
    turma.name = code
    turma.time = "35M12"
  end
end

And("a valid SIGAA file containing the class {string} is available") do |code|
  # O CSV de amostra contém a turma CIC0097; reutilizá-lo garante o upload
  # com um arquivo real que já contém a turma informada.
  @sigaa_file = Rails.root.join("db/amostra_sigaa.csv")
end

Then("the class {string} should not be duplicated in the database") do |code|
  expect(Turma.where(code: code).count).to eq(1)
end

Then("I should be on the home page") do
  expect(page).to have_current_path('/')
end
