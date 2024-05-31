Feature: Generate Admin Report
    As an administrator
    I want to download a csv file containing the results of a form
    So that I can evaluate class performance

  Background: Starting on the class results page
    Given I am on the Resultados page

  Scenario: Click on class report to download result (happy path)
    Given I have sent a form to "Turma"
    When I press "Turma"
    Then I should see "Relatório baixado com sucesso."

  Scenario: Disable button after clicking once (sad path)
    When I press "Turma"
    Then I should not be able to press "Turma"
