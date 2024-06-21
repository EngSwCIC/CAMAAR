require 'cucumber/rspec/doubles'

Given("I am logged in") do
  @user = User.new(
    :email => "teste@email.com",
    :matricula => "abc123",
    :password => "senha123",
    :password_confirmation => "senha123"
  )

  @user.save!

  login_as(@user, scope: :user)
end

Then(/^the classes, subjects, and participants should be added to the database if they do not already exist$/) do
  expect(StudyClass.find_by code: "CIC0000", classCode: "TA", semester: "2024.1").not_to be nil
  expect(User.find_by matricula: "54321").not_to be nil
end

Given(/^there are existing classes, subjects, and participants in the database$/) do
  @existing_class = StudyClass.create(code: "CIC0000", classCode: "TA", semester: "2024.1")

  aluno = User.new(nome: "Silva", matricula: "54321", email: "silva@email.com")
  aluno.skip_password_validation = true
  @existing_participant1 = aluno.save

  professor = User.new(nome: "FULANO DE CICLANO", matricula: "12345", email: "fulano@email.com")
  professor.skip_password_validation = true
  @existing_participant2 = professor.save
end

Then(/^the existing data should not be duplicated$/) do
  # Check that there are no duplicates in the database
  expect(StudyClass.where(code: "CIC0000", classCode: "TA", semester: "2024.1").count).to eq(1)
  expect(User.where(matricula: "54321").count).to eq(1)
end

When(/^I press Importar dados$/) do
  RSpec::Mocks.with_temporary_scope do
    allow(File).to receive(:read).with("classes.json").and_return(@data_classes)
    allow(File).to receive(:read).with("class_members.json").and_return(@data_members)

    steps %{When I press "Importar Dados do Sigaa"}
  end
end

Given(/^I have valid JSONs$/) do
  @data_classes = <<-EOF
        [ {"code": "CIC0000", "name": "TESTE", "class": { "classCode": "TA", "semester": "2024.1", "time": "25M34"} } ]
  EOF

  @data_members = <<-EOF
    [ { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", 
        "dicente": [{
          "nome": "Silva",
          "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
          "matricula": "54321",
          "usuario": "54321",
          "formacao": "graduando",
          "ocupacao": "dicente",
          "email": "silva@email.com"
        }],
        "docente": { 
          "nome": "FULANO DE CICLANO", "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" 
        } 
      } 
    ]
  EOF
end

Given /^I don't have valid JSONs$/ do
  @data_classes = <<-EOF
    [ {"code": "CIC0000", "class": { "classCode": "TA", "semester": "2024.1", "time": "25M34"} } ]
  EOF

  @data_members = <<-EOF
    [ { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", "docente": { 
      "nome": "FULANO DE CICLANO", "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" } 
    } ]
  EOF
end