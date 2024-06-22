Feature: Sign on User in the website

    Me as an Administrator
    I want to register participants of SIGAA classes when importing new user data into the system
    In order for them to access the CAMAAR system

Background:

    Given I imported data from SIGAA 
    And the student "Fulano" with email "fulano@detal.com" is participant of a SIGAA class

Scenario: System sent an email for potential user imported from SIGAA 

    Given "Fulano" was not already registred
    Then an email should be sent to "fulano@detal.com" containing a link
    When "Fulano" click the link
    Then should be on the password definition page
    And should see "Fulano"

Scenario: System not sent an email because the user is already registred

    Given "Fulano" is already registred with email "fulano@detal.com" and password "pass" exists
    Then an email shoud not be sent to "fulano@detal.com" containing a link

Scenario: The link was invalid because the user already registred himself

    Given "Fulano" was not already registred
    Then an email should be sent to "fulano@detal.com" containing a link
    When "Fulano" registred himself with password "pass"
    And "Fulano" click the link again
    Then "Fulano" should see an error message saying "O link expirou. O usuário já foi cadastrado"
