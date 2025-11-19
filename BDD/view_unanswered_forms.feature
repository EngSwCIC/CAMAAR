Feature: View forms to answer
  As a Class Participant
  I want to view unanswered forms for the classes I am enrolled in
  In order to choose which one to answer

  Scenario: Happy Path - View unanswered forms
    Given that I am on the "Student" screen
    Then I should see all "Unanswered Forms"
    And I should see a "Answer Form" button for each one
    When I click the "Answer Form" button
    Then I should be taken to the "Form Screen"

  Scenario: Sad Path - No forms available
    Given that I am on the "Student" screen
    And there are no existing forms
    Then I should see a text box saying "No forms available"