Feature: Manage form templates
  As an Administrator
  I want to view, edit, and delete form templates I have created
  Without affecting evaluation forms already created from them
  So that I can organize the existing templates

  Background:
    Given I am logged in as an administrator
    And And a template named "Avaliação de matéria" exists
    And a template named "Avaliação semestral" exists

  Scenario: Edit a template without affecting existing forms
    When I edit the template "Avaliação semestral"
    And I update a question
    And I save the changes
    Then the template should be updated
    And existing evaluation forms should remain unchanged

  Scenario: Delete a template without affecting existing forms
    When I delete the template "Avaliação semestral"
    Then the template should be removed from the template list
    And existing evaluation forms should remain accessible

  Scenario: Try to delete a already deleted template
    Given I have deleted the template ""Avaliação semestral"
    And the page hasn't reloaded
    When I try to delete the template "Avaliação semestral"
    Then the system should show the error message "Template não existente"