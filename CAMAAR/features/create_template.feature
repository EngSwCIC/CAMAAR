Feature: Create Form Template

  Scenario: Template created successfully with valid data
    Given I am an admin
    And I am on the gerenciamento - templates page
    When I click the add button
    And I enter a valid name
    And I add at least one question
    Then the new template should appear in the template list

  Scenario: Tried to create a template with no questions
    Given I am an admin
    And I am on the gerenciamento - templates page
    When I click the add button
    And I do not add questions
    Then I should receive an error that I should add questions

  Scenario: Tried to create a template with no name
    Given I am an admin
    And I am on the gerenciamento - templates page
    When I click the add button
    And I enter a invalid name
    Then I should receive an error that I should add a name
