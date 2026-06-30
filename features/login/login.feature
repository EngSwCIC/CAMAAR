Feature: User Login

  Background:
    Given there is a user with email "aluno4@camaar.com" and password "password123"

  Scenario: Successful Login
    Given the user is on the login page
    When the user fills "aluno4@camaar.com" in the username field
    And the user fills "password123" in the password field
    And the user clicks "Log in" button
    Then the user should be redirected to the dashboard

  Scenario: Unsuccessful Login
    Given the user is on the login page
    When the user fills "invalid_username" in the username field
    And the user fills "invalid_password" in the password field
    And the user clicks "Log in" button
    Then I should see the message "Invalid email or password"

  Scenario: Empty Fields
    Given the user is on the login page
    When the user leaves "Email" field empty
    And the user leaves "Password" field empty
    And the user clicks "Log in" button
    Then I should see the message "Invalid email or password"