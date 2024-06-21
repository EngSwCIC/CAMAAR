Feature: Sending Email to SIGAA Class Participants

  Scenario: Sending email upon importing new users
    Given I am logged in as an Administrator in the system
    And I have access to the functionality of importing new users
    When I import the data of new users
    Then the class participants should receive an invitation email
    And the email should contain instructions to access and register in the system

  Scenario: Email is not sent if there are no class participants
    Given I am logged in as an Administrator in the system
    And I have access to the functionality of importing new users
    When I import the data of new users without including SIGAA class participants
    Then no invitation email should be sent

  Scenario: Email is not sent if the import fails
    Given I am logged in as an Administrator in the system
    And I have access to the functionality of importing new users
    When an error occurs during the import of new users' data
    Then no invitation email should be sent