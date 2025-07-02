Feature: Password setup and reset
  As a User
  I want to set my password when I receive an account creation email
  And I want to reset my password when I forget it
  So that I can securely access the system

  Background:
    Given I am a registered user

  Scenario: Reset password via reset email
    Given I have requested a password reset
    And I have received an email with a reset link
    When I follow the reset link
    And I enter a new valid password
    Then my password should be updated
    And I should be able to log in with the new password

  Scenario: Fail to reset password due to invalid password
    When I enter a invalid password
    Then I should see "Senha inválida"
