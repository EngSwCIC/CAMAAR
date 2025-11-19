Feature: Password reset from email link
  As a User
  I want to reset my password using a secure email link
  In order to regain access to my account when I forget my password

  Scenario: Happy Path - Successfully reset password
    Given that I requested password reset on the login screen
    And I received an email containing the link to reset my password
    And the link is still valid and has not expired
    When I access the link
    And I enter a valid new password
    And I confirm the new password correctly
    And I click the confirm button
    Then the system must save the new password
    And must change my user status to "active" if it is pending
    And must redirect me to the login page
    And must display a message informing that the password was successfully reset.

  Scenario: Sad Path - Expired link
    Given that I received an email containing the password reset link
    When I try to access the link after the validity period
    Then the system must block the reset
    And must display a message informing that the link has expired
    And must offer the option to request a new reset link

  Scenario: Sad Path - Invalid password or outside standards
    Given that I am on the password reset page
    When I enter a password that doesn't meet minimum requirements
    And click confirm
    Then the system must prevent the reset
    And must display a message explaining the allowed password criteria.

  Scenario: Sad Path - Password confirmation mismatch
    Given that I am on the password reset page
    When I enter the new password
    And I enter a different password confirmation
    And click confirm
    Then the system must prevent saving the new password
    And must display a message indicating that the passwords do not match.