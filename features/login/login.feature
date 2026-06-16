Feature: User Login

  Background:
    Given the following users exist:
      | email              | password       | perfil  |
      |aluno3@camaar.com   | valid_password | discente|

  Scenario: Successful Login
    Given I am on the login page
    When I fill "admin@camaar.com" in the username field
    And I fill "valid_password" in the password field
    And I click the "Log in" button
    Then I should be redirected to the dashboard

  Scenario: Unsuccessful Login
    Given I am on the login page
    When I fill "invalid_username" in the username field
    And I fill "invalid_password" in the password field
    And I click the "Log in" button
    Then I should see the message "Invalid email or password."

  Scenario: Empty Fields
    Given I am on the login page
    When I leave "username" field empty
    And I leave "password" field empty
    And I click the "Log in" button
    Then I should see the message "Invalid email or password."