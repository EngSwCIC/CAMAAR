Feature: Visualization of form results
  As an administrator
  I want to go to the management page
  So that I can view the results of forms

Background:
    Given I am logged in as an administrator
    And I am on the evaluations webpage
    When I click on "Resultados"
    Then I should see the list of form results

Scenario: Admin views the list of results forms
    Then I should see a list of form results

Scenario: Admin views the list of forms with no forms created
    Given there are no forms created
    When I am on the forms results page
    Then I should see a message "Nenhum formulário criado"

Scenario: Non-admin user tries to view the list of forms
    Given I am logged in as a regular user
    When I click on "Resultados"
    Then I should see an error message "Você deve ser administrador para acessar essa página."
