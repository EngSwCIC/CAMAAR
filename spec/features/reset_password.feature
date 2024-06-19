Feature: Password Reset

  Scenario: Request password reset
    Given I am on the login page
    When I request to reset my password
    Then I should be redirected to the forgot_password page
    And I enter my email address
    And I submit the password reset request
    Then I should receive an email with instructions
    And I should be redirected to the token_forgot_password_page
  
  Scenario: Reset password with non-existent email
    Given I am on the login page
    When I request to reset my password
    Then I should be redirected to the forgot_password page
    And I enter a fake email address
    And I submit the password reset request
    Then I should see an error message

  Scenario: Reset password with correct code
    Given I have received a password reset email with a code
    And I am on the token_forgot_password page
    When I enter the correct reset code
    Then I should be redirected to the reset_password page

  Scenario: Reset password with incorrect code
    Given I have received a password reset email with a code
    And I am on the token_forgot_password page
    When I enter the incorrect reset code
    Then I should see an error message

  Scenario: Change password after entering new password
    Given I am on the reset_password page
    And I enter my new password
    And I confirm my new password
    When I submit the new password
    Then I should be redirected to the login page
    And I should see a success message

  Scenario: Reset password with mismatched passwords
    Given I am on the reset_password page
    And I enter my new password
    And I enter mismatched passwords
    When I submit the new password
    Then I should see an error message