Feature: Reset password via email

  Scenario: User resets password using link received by email
    Given I am user
    And I am on "/redefinir-senha" page
    And I have requested a password reset
    And I have received an email with a reset link
    When I follow the reset link
    Then I should see the password reset form
    When I fill the "New password" field with "newpass123"
    And I fill the "Confirm password" field with "newpass123"
    And I submit the reset password form
    Then I should see a confirmation that my password has been changed
    And I can sign in with email "user@example.org" and password "newpass123"

  Scenario: User follows an expired or invalid reset link
    Given I am user
    And I am on "/redefinir-senha" page
    And I have requested a password reset
    And the reset link is expired or invalid
    When I follow the reset link
    Then I should see an error message saying the reset link is invalid or has expired
    And I should be offered the option to request a new password reset