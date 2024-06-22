Feature: User can answer the form

  As a user
  I want to answer an evaluation form
  So that I can provide feedback on a specific discipline and teacher for a given period

Background: 

    Given I am on the evaluations webpage
    And I select a discipline, teacher, and period

Scenario: Successfully answering the form
      
    When I navigate to the form
    And I fill out the form with valid responses
    And I submit the form
    Then I should see a confirmation message indicating the form was submitted successfully

Scenario: Attempting to submit an incomplete form

    When I navigate to the form
    And I fill out the form with incomplete responses
    And I submit the form
    Then I should see an error message indicating that all questions must be answered