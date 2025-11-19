# language: en
Feature: Password setup system (#105)
  As a User
  I want to set a password for my account using the link I receive by email from the registration request
  So that I can access the system

  Background:
    Given there is a pending user who received a password setup email with a valid token

  Scenario: Set password successfully from email link
    When I open the password setup link
    And I set a new valid password and confirmation
    Then my account becomes active
    And I can sign in with my new credentials

  Scenario: Invalid or expired token
    Given my password setup token is invalid or expired
    When I open the password setup link
    Then I see an error indicating the link is invalid or expired
    And I am offered a way to request a new password setup email

  Scenario: Password confirmation mismatch
    When I open the password setup link
    And I enter a password and a non-matching confirmation
    Then I see a validation error about the confirmation not matching
    And my account remains pending until I set a valid password

  Scenario: Token can be used only once
    When I successfully set a password using the email link
    And I try to use the same link again
    Then I see an error that the token has already been used
    And I remain signed in with my new credentials
