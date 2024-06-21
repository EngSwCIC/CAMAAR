Feature: Importing data from SIGAA

  Scenario: Importing for the first time
    Given I am logged in as an administrator
    And I am on the Management page
    When I import data from SIGAA
    Then the importing should be successful
