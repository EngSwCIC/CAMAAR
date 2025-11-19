Feature: Login system
  As a system user
  I want to access the system using a registered email or registration number and password
  In order to answer forms or manage the system

  Scenario: Happy Path - Student login
    Given that I am on the login screen as an student
    Then I am presented with 2 input fields, one for email/registration and another for password
    When filling with valid and matching email/registration and password
    When clicking the login button
    Then I should be redirected to the Evaluations screen, with a sidebar and available evaluations

  Scenario: Happy Path - Admin login
    Given that I am on the login screen as a admin
    Then I am presented with 2 input fields, one for email/registration and another for password
    When filling with valid and matching email/registration and password
    When clicking the login button
    Then I should be redirected to the Evaluations screen, with a sidebar showing the evaluations and management sections.

  Scenario: Sad Path - Invalid credentials
    Given that I am on the login screen
    Then I am presented with 2 input fields, one for email/registration and another for password
    When filling with valid email/registration but incompatible password
    Then I am presented with a message that user or password is incorrect