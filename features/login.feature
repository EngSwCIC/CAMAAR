Feature: Access System with Email or Registration Number and Password

  Scenario: Log in with email and password
    Given I am on the login page
    When I enter my email
    And I enter my password
    And I click the "Login" button
    Then I should be logged in to the system

  Scenario: Log in with registration number and password
    Given I am on the login page
    When I enter my registration number
    And I enter my password
    And I click the "Login" button
    Then I should be logged in to the system

  Scenario: Attempt to log in with incorrect credentials
    Given I am on the login page
    When I enter incorrect email or registration number
    And I enter incorrect password
    And I click the "Login" button
    Then I should see an error message "Incorrect email, registration number, or password. Please try again."