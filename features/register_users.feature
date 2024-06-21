Feature: Register users to the system
    As an Administrator
    I want to register SIGAA class participants when importing new user data into the system
    So that they can access the CAMAAR system

  Background: I have valid JSON files
    Given I have valid JSONs

  Scenario: Register users (happy path)
    Given I am on the Gerenciamento page
    And there are no users registed in our system
    When I press Importar dados
    Then I should be on the Gerenciamento page
    And I should see "Data imported successfully"
    Then I should have a new user in the database
    And I should see "Usuários cadastrados com sucesso."

  Scenario: No updates (sad path)
    Given I am on the Gerenciamento page
    And all users were imported
    When I press Importar dados
    Then I should be on the Gerenciamento page
    And I should see "Sem novos usuários."
