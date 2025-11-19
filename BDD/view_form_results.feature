Feature: View form results
  As an Administrator
  I want to view the created forms
  In order to generate a report from the responses

  Scenario: Happy Path - View form responses
    Given that I am on the admin screen
    Then I should see a sidebar menu with a management option
    When I click the management button
    Then I should be redirected to a screen with all created forms available
    And I should see a menu with the option to view responses for each form
    When clicking the view responses button
    Then I should be directed to a page containing all user responses for viewing.

  Scenario: Sad Path - No responses available
    Given that I am on the admin screen
    Then I should see a sidebar menu with a management option
    When I click the management button
    Then I should be redirected to a screen with all created forms available
    And I should see a menu with the option to view responses for each form
    When clicking the view responses button
    Then I am presented with a message that there are no submitted responses.