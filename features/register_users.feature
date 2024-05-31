Feature: Register users to the system
    As an Administrator
    I want to register SIGAA class participants when importing new user data into the system
    So that they can access the CAMAAR system

  Scenario: Register users (happy path)
    Given I am on the Gerenciamento page
    And there are users not yet imported
    When I press "Importar dados"
    Then I should be on the Gerenciamento page
    And I should see "Dados importados com successo."
    Then I go to the signup page
    When I sign up with "123456"
    Then I should see "Usuário cadastrado com sucesso."

  Scenario: No updates (sad path)
    Given I am on the Gerenciamento page
    And all users were imported
    When I press "Importar dados"
    Then I should be on the Gerenciamento page
    And I should see "Sem novos dados."
