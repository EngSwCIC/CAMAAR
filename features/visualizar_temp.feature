Feature: View and manage form templates
  As an Administrator
  I want to view the list of form templates I have created
  So that I can choose to edit or delete them as needed

  Background:
    Given I am logged in as an administrator

  Scenario: View templates I created
    Given I have created a template named "Avaliação de matéria"
    When I access the templates management page
    Then I should see the template named "Avaliação de matéria"

  Scenario: No templates created
    Given no templates have been created
    When I access the templates management page
    Then I should see a message "Não há nenhum template"

  Scenario: No templates created by me
    Given I haven't created any templates
    When I access the templates management page
    Then I should see the templates made by other administrators