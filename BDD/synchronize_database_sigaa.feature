Feature: Synchronize database with SIGAA
  As an Administrator
  I want to update the existing database with current SIGAA data
  In order to correct the system database

  Scenario: Happy Path - Successfully synchronize database
    Given that I am logged in as Administrator
    And I access the "Update SIGAA Database" functionality
    And the system can communicate correctly with SIGAA
    When I start the update
    Then the system must identify all SIGAA users that already exist in the internal database
    And must update only allowed data (name, registration number, affiliation)
    And must log which users were updated and which fields were modified
    And must display a message informing that the update was successfully completed.

  Scenario: Sad Path - Inconsistent SIGAA data
    Given that I am logged in as Administrator
    And I access the database update functionality
    When the system receives invalid, incomplete, or inconsistent data from SIGAA
    Then the update must be canceled
    And no modification must be saved
    And an error message must be displayed informing that SIGAA data is invalid
    And the system must suggest trying again later.

  Scenario: Sad Path - Communication failure with SIGAA
    Given that I am logged in as Administrator
    And I access the database update functionality
    When a communication failure with SIGAA occurs
    Then the system must interrupt the operation
    And no changes must be made
    And an error message must be displayed informing that communication with SIGAA was not possible
    And the system must guide the Administrator to check the connection or try again.