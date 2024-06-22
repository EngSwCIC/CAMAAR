Feature: Form creation based on template for class evaluation
  As an administrator
  I want to create a form based on a template for the classes I choose
  So that I can evaluate the performance of the classes in the current semester

Background:
    Given I am logged in as an administrator
    And I am on the form creation page

Scenario: Admin creates a form based on a template for selected class
    Given there are available templates for form creation
    And there are available classes to evaluate
    When I select a template
    And I select the class I want to evaluate
    And I add text for the questions to the form
    And I click on "Criar formulário"
    Then the form should be created for the selected class
    And I should see a confirmation message "Formulário criado com sucesso."


Scenario: Admin tries to create a form without adding questions
    Given there are available templates for form creation
    And there are available classes to evaluate
    When I select a template
    And I select the classes I want to evaluate
    And I click on "Criar formulário"
    Then I should see an error message "Você deve adicionar questões ao formulário antes de criá-lo"
    And the form should not be created