Feature: Create a new password from email

  Background:
    Given I am on the "Login" page
    And I click on "First Access"

  Scenario: Create a new password with valid data
    Given I am on the "Create Password" page
    And I fill "ValidEmail" in the email field
    And I click on "Login"
    Then I should be on the "Create Password" page
    And I fill in the password field with "SecurePass123"
    When I click on "Create Password"
    Then I should see a "Your password has been created successfully." message

  Scenario: Create a new password with invalid email
    Given I am on the "Create Password" page
    And I fill "InvalidEmail" in the email field
    And I click on "Login"
    Then I should see an "Invalid email address." error message

  Scenario: Create a new password with bad password
    Given I am on the "Create Password" page
    And I fill "ValidEmail" in the email field
    And I click on "Login"
    Then I should be on the "Create Password" page
    And I fill in the password field with "123"
    When I click on "Create Password"
    Then I should see a "Password must be at least 8 characters long." error message