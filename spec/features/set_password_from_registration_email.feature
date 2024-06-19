Feature: Set Password from Registration Email

  Scenario: Set password from registration email
    Given I am a User who has been notified to register myself by an email
    When I click on the registration link in the email
    Then I should be redirected to the forgot_password page
    And I should enter my email address
    And I should submit the password reset request
    Then I should receive an email with registration instructions
    And  I should be redirected totoken_forgot_password_page

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