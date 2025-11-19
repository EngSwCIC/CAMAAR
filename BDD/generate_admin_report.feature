Feature: Generate admin report
  As an Administrator
  I want to download a CSV file containing form results
  In order to evaluate class performance

  Scenario: Happy Path - Successfully generate report
    Given that I am on the admin screen
    Then I should see a sidebar menu with a management option
    When I click the management button
    Then I should be redirected to a screen with all created forms available
    And I should see a menu with the option to generate report for each form
    When clicking the generate report button
    Then the download of a CSV file containing the form results and graphs should start.

  Scenario: Sad Path - No responses to generate report
    Given that I am on the admin screen
    Then I should see a sidebar menu with a management option
    When I click the management button
    Then I should be redirected to a screen with all created forms available
    And I should see a menu with the option to generate report for each form
    When clicking the generate report button
    Then I am presented with a message that it is not possible to generate a report because there are no submitted responses.