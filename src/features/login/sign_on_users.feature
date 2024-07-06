Feature: Sign on User in the website

    Me as an Administrator
    I want to register participants of SIGAA classes when importing new user data into the system
    In order for them to access the CAMAAR system

Background:

    Given the student "Fulano" with email "fulano@detal.com" is participant of a SIGAA class

Scenario: System sent an email for potential user imported from SIGAA 

    Given "Fulano" was not already registred
    When I import data from SIGAA
    When "fulano@detal.com" opens the email
    Then an email should be sent to "fulano@detal.com" containing a link
    When I click "Definir Senha" email link
    Then I should be on the password definition page
    And I should see "Fulano"

Scenario: System not sent an email because the user is already registred

    Given "Fulano" was already registred with email "fulano@detal.com" and password "password" exists
    When I import data from SIGAA
    Then an email shoud not be sent to "fulano@detal.com" containing a link