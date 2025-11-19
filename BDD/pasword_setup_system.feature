Feature: Password setup system
  As a User
  I want to set a password for my user from the registration request email
  In order to access the system

  Background:
    Given that the user "fulano.novo@email.com" was imported and has "pending" status
    And a valid password setup link was sent to "fulano.novo@email.com"

  Scenario: Happy Path - Successfully set password
    Given that the user accesses the password setup link sent by email
    And the link is valid and within the deadline
    When the user enters a new password that meets the requirements
    And confirms the same password correctly
    And confirms the password creation
    Then the password must be successfully registered
    And the user status must be updated to "active"
    And the user must be directed to the login page

  Scenario: Sad Path - Expired link
    Given that the user accesses the password setup link received by email
    And the link is expired
    When the user tries to set a new password
    Then the system must display a message informing that the link has expired
    And must guide the user to request a new link

  Scenario: Sad Path - Invalid password requirements
    Given that the user accesses the password setup link sent by email
    And the link is still valid
    When the user enters a password that doesn't meet security rules
    Then the system must display a message explaining the mandatory password criteria
    And the password must not be saved

  Scenario: Sad Path - User already active
    Given that the user accesses the password setup link received previously
    And the user's current status is "active"
    When the user tries to create the initial password
    Then the system must prevent the action
    And must suggest the user use the "forgot my password" flow