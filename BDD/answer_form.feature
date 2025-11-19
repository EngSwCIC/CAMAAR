Feature: Answer form
  As a Class Participant
  I want to answer the questionnaire about the class I am enrolled in
  In order to submit my class evaluation

  Scenario: Happy Path - Successfully submit response
    Given that I am on the "Form Screen"
    And I must be able to view all questions
    And I must be able to answer all available questions
    When clicking "Submit response"
    Then I am presented with a message that the response was successfully submitted.

  Scenario: Sad Path - Session expired
    Given that I am on the "Form Screen"
    And I must be able to view all questions
    And I must be able to answer all available questions
    When clicking "Submit response"
    Then I am presented with a message that the session has ended and login is required again.