Then("I should see the message {string}") do |message|
  expect(page).to have_content(message)
end

And("the system database is empty") do
  Klass.destroy_all if defined?(Klass)
  Subject.destroy_all if defined?(Subject)
  User.where.not(role: "admin").destroy_all if defined?(User)
end

And("I navigate to the {string} page") do |page|
  paths = {
    "Importação SIGAA" => "/admin/import"
  }
  visit(paths[page] || "/admin/#{page.downcase.tr(' ', '_')}")
end

Given("a valid SIGAA file with classes, subjects and participants is available") do
  @sigaa_full_file = Rails.root.join("spec/fixtures/sigaa_full_valid.json")
end

When("I upload the SIGAA import file") do
  attach_file("sigaa_file", @sigaa_full_file)
end

Then("the system should create the classes in the database") do
  expect(Klass.count).to be > 0
end

And("the system should create the subjects in the database") do
  expect(Subject.count).to be > 0
end

And("the system should create the participants in the database") do
  expect(User.where.not(role: "admin").count).to be > 0
end

Given("the class {string} already exists in the system") do |code|
  Klass.find_or_create_by(code: code)
end

And("a valid SIGAA file containing the class {string} is available") do |code|
  @sigaa_full_file = Rails.root.join("spec/fixtures/sigaa_with_#{code}.json")
end

Then("the class {string} should not be duplicated in the database") do |code|
  expect(Klass.where(code: code).count).to eq(1)
end
