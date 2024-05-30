Feature: Register new user
  As an administrator, I want to register new users in the system

Background: I am a logged-in administrator
  Given I am logged in as an administrator

Scenario: Administrator successfully registers a new user (Happy path)
  Given I am on the "Register User" page
  When I fill in the user details with valid information
  And I click on 'Register'
  Then I should see "Usuario criado com sucesso"

Scenario: Administrator tries to register a new user with missing information (Sad path)
  Given that I am on the "Register User" page
  When I leave a field empty
  And I click 'Register'
  Then I should see "Erro, preencha todos os campos"

Scenario: Administrator tries to register a new user with invalid email (Sad path)
  Given I am on the "Register User" page
  When I fill in the user details with an invalid email
  And I click on 'Register'
  Then I should see "Erro, o email inserido não é valido.Por favor, ensira um email valido"

Scenario: Administrator tries to register a new user with name invalid (Sad path)
  Given I am on the "Register User" page
  When I fill in the user details with an invalid name
  And I click on 'Register'
  Then I should see "Erro, o nome inserido não é valido.Ensira um nome com mais de 3 caracteres e sem caracteres especiais."

Scenario: Administrator tries to register a new user with registration invalid (Sad path)
  Given I am on the "Register User" page
  When I fill in the user details with an invalid registration
  And I click on 'Register'
  Then I should see "Erro, a matricula inserida não é valida.Ensira uma matricula no seguinte formato XXXXXXXXX, em que X representa um digito entre 0 e 9"