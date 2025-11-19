# language: en
Feature: Create evaluation form from template (#103)
  As an Administrator
  I want to create an evaluation form based on a template for the classes I choose
  So that I can evaluate class performance in the current semester

  Background:
    Given I am authenticated as an administrator
    And there is at least one evaluation template available
    And there are classes available for the current semester

  Scenario: Create forms for selected classes using a template
    When I select a template and choose one or more classes
    And I confirm the creation of forms
    Then the system creates one evaluation form per selected class for the current semester
    And I see a success message indicating how many forms were created

  Scenario: Prevent duplicate forms for the same class and semester
    Given there is already an evaluation form for a class in the current semester
    When I try to create forms again using the same template for the same class
    Then the system does not create a new form for that class and semester
    And I see a message indicating the form already exists

  Scenario: Validation error when no template is selected
    When I try to create forms without selecting a template
    Then I see a validation error indicating a template is required
    And no forms are created
