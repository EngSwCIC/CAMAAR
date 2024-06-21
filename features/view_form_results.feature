Feature: View form results
  As an Administrator
  I want to visualize created forms
  So that I can generate a report from the answers

  Scenario: No forms created (sad path)
    Given I am logged in as the admin
    And no form has been answered
    And I am on the Resultados page
    Then I should not see "Turma 1"

  Scenario: A form was sent (happy path)
    Given I am logged in as the admin
    And a form has been answered
    And I am on the Resultados page
    Then I should see "Turma 1"
