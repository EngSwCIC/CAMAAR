Feature: View form results
  As an Administrator
  I want to visualize created forms
  So that I can generate a report from the answers

  Scenario: No forms created (sad path)
    Given I am logged in as the admin
    And a form has been answered
    And I am on the Form Results page
    Then I should see form "Turma1"

  Scenario: A form was sent (happy path)
    Given I have sent a form to "Turma"
    And I am on the Gerenciamento page
    When I press "Resultados"
    Then I should be on the Resultados page
    And I should see "Turma"
