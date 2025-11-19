# language: en
Feature: Register system users (#100)
  As an Administrator
  I want to register participants of SIGAA classes by importing new users into the system
  So that they can access the CAMAAR system

  Note:
    Although this is called "registration", at this stage the user is created in a pending state
    and a request to set a password is sent. The registration is only completed after the password is set.

  Background:
    Given I am authenticated as an administrator

  Scenario: Import new participants and send password setup request
    Given there are participants in SIGAA who do not have a user in the system yet
    When I import the participants from SIGAA
    Then the system creates pending activation records for each imported participant
    And the system sends a password setup request email to each new participant
    And the participants cannot access the system until they set their passwords

  Scenario: Do not create duplicate users on import
    Given there is already a user registered for a SIGAA participant
    When I import the participants from SIGAA again
    Then the system does not create a new user for that participant
    And the system does not send the password setup request again for that participant

  Scenario: Partial import failure
    Given some SIGAA records are incomplete or invalid
    When I import the participants from SIGAA
    Then the system logs the import errors for review
    And the system continues the import for the other valid participants
