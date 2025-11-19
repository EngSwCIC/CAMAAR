Feature: Register system user
  As an Administrator
  I want to register SIGAA class participants by importing new user data into the system
  So they can access the CAMAAR system

  Scenario: Happy Path - New users are registered
    Given that I am logged in as Administrator in the panel
    And I access the import SIGAA data functionality for a class
    When I perform the data import
    Then the system must identify users (teachers and students) that do not exist in the CAMAAR database
    And must create a new record for each non-existent user, with "pending" status
    And must save their basic data, including email, registration number, and name
    And must automatically send an email requesting the user to set their initial password
    And must display a message confirming that new users were successfully imported and registered.

  Scenario: Sad Path - Already registered users
    Given that I perform the SIGAA data import for a class
    When the system finds a user whose email is already registered in CAMAAR
    Then the system must not create a new record
    And must not send a new password setup email
    And must simply ignore this user, maintaining the existing data
    And must display a warning that "X users were already registered and thus ignored".

  Scenario: Sad Path - SIGAA data import failure
    Given that I try to import SIGAA data for a class
    When a communication failure with SIGAA occurs or the data returns invalid
    Then the system must display an error message stating that the import could not be completed
    And no user should be created, updated, or modified.