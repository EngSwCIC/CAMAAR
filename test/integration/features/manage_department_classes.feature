Feature: Manage department classes

  Scenario: View my department's classes
    Given I am an authenticated Administrator of the system
    When I access the class management page
    Then I should see a list of classes belonging to my department

  Scenario: Attempt to access classes from another department
    Given I am an authenticated Administrator of the system
    When I try to access the page of a class that does not belong to my department
    Then I should receive an access denied message