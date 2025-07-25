Feature: Create Form Template
  As an Administrator
  I want to create a form template containing the questions
  So that I can generate evaluation forms to assess class performance

  Background:
    Given I am logged in as an administrator

  Scenario: Create a form template with valid text question
    When I click to create a new template
    Then I should see a blank form with a field to name the template and an initial question
    Then I fill in the template name
    And I select the question type "Texto"
    And I provide a question statement
    And I save the template
    Then the system should confirm "Template criado"
    And the template should be available in the list

  Scenario: Create a form template with valid "radio" question
    Given I am on a new template creation page
    And I have filled the template name
    When I select the question type "Radio"
    Then I should see fields to enter the question and define the possible answer options
    When I fill in the question and provide valid options
    And I save the template
    Then the system should confirm "Template criado"
    And the template should be available in the list

  Scenario: Create a form template with valid "escala" question
    Given I am on a new template creation page
    And I have filled the template name
    When I select the question type "Escala"
    And I fill in the question statement
    And I save the template
    Then the system should confirm "Template criado"
    And the template should be available in the list

  Scenario: Try to create a template without questions
    When I create a new form template
    And I fill in the template name
    And I do not add any questions
    And I attempt to save the template
    Then the system should show the error message "Template vazio"

  Scenario: Try to create a template without a name
    When I attempt to save a new form template
    And I don't provide a name
    And I attempt to save the template
    Then the system should show the error message "Template não nomeado"
