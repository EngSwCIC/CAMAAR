Feature: Register users to the system
    As an Administrator
    I want to register SIGAA class participants when importing new user data into the system
    So that they can access the CAMAAR system

  Background: Starting on the admin actions page
    Given I am on the Gerenciamento page

  Scenario: Register user (happy path)
    When I press "Importar dados"
    Then I should be on the Gerenciamento page
    And I should see "Dados importados com successo."
    Then I go to the signup page
    When I sign up with "123456"
    Then I should see "Usuário cadastrado com sucesso."