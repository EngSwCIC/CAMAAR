Feature: Generate Admin Report
    As an administrator
    I want to download a csv file containing the results of a form
    So that I can evaluate class performance

  Scenario: Click on class report to download result (happy path)
    Given I have sent a form to "Turma"
    And I have answered a form from "Turma"
    And I am on the Gerenciamento page
    When I press "Resultados"
    Then I should be on the Resultados page
    And I should see "Turma"
    When I press "Turma"
    Then I should see "Relatório baixado com sucesso."

  Scenario: No results (sad path)
    Given I am on the Gerenciamento page
    And I have sent a form to "Turma"
    Then I should not be able to press "Resultados"
