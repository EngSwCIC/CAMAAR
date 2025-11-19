Feature: Import data from SIGAA
  As an Administrator
  I want to import data from SIGAA regarding classes, subjects, and participants
  In order to populate the system's database

  Scenario: Happy Path - Successfully import classes
    Given that I am on the admin screen
    Then I should see a field "Insert Course Code"
    When I insert the "Code"
    And I click on "Search"
    Then I should see the "Classes" for the course
    And I should see an "Add" button for each one
    When I click the "Add" button
    Then the "Classes" are added to the "database"

  Scenario: Sad Path - Attempt to add existing class
    Given that I am on the admin screen
    Then I should see a field "Insert Course Code"
    When I insert the "Code"
    And I click on "Search"
    Then I should see the "Classes" for the course
    And I should see an "Add" button for each one
    When I click the button
    And it is an "Existing Class"
    Then I see a warning "The class is already in the database"