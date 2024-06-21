Feature: Importing data from SIGAA

  Scenario: Importing from SIGAA successfully
    Given I am logged in as an administrator
    And I am on the Management page
    When I click the "import" button
    Then the importing should be successful
