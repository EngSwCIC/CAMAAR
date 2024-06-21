Feature: User Login
  Scenario: Logging in with valid credentials
    Given I am on the login page
    When I fill in "Email" with "teste1@example.com"
    And I fill in "Password" with "teste1"
    And I click on the "Log in" button