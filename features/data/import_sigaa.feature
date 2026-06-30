Feature: Initial import of SIGAA data
  As an Administrator
  I want to import class, subject and participant data from SIGAA if it does not exist in the database
  So that I can populate the system database

  Background:
    Given I am logged in as the "Administrador" profile
    And the system database is empty
    And I navigate to the "Importação SIGAA" page

  Scenario: [Happy Path] Import non-existent SIGAA data
    Given a valid SIGAA file with classes, subjects and participants is available
    When I upload the SIGAA import file
    And I click the "Importar e Enviar Convites" button
    Then the system should create the classes in the database
    And the system should create the subjects in the database
    And the system should create the participants in the database
    And I should see the message "Usuários importados e convites enviados com sucesso!"

  Scenario: Ignore already existing records during import
    Given the class "CIC0097" already exists in the system
    And a valid SIGAA file containing the class "CIC0097" is available
    When I upload the SIGAA import file
    And I click the "Importar e Enviar Convites" button
    Then the class "CIC0097" should not be duplicated in the database
    Then I should be on the home page
    And I should see the message "Usuários importados e convites enviados com sucesso!"
