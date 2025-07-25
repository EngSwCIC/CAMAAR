Feature: Login System
  As a system user
  I want to log in using either an email or registration number and a registered password
  So that I can answer forms or manage the system

  Background:
    Given I am on the login page
    And a regular user exists with email "user@gmail.com" and registration number "012345678" and password "password1"

  Scenario: Successful login with email and password (regular user)
    When I attempt to log in with email "user@gmail.com" and password "pass01"
    Then the login should be successful
    And I should see the forms dashboard
    And the sidebar menu should not show the management option

  Scenario: Successful login with registration number and password (regular user)
    When I attempt to log in with registration number "012345678" and password "pass01"
    Then the login should be successful
    And I should see the forms dashboard
    And the sidebar menu should not show the management option

  Scenario: Successful login with registration number and password (regular user)
    When I attempt to log in with registration number "012345678" and password "pass01"
    Then the login should be successful
    And I should see the forms dashboard
    And the sidebar menu should not show the management option

  Scenario: Successful login with admin credentials
    When I attempt to log in with email "admin@gmail.com" and password "admin1"
    Then the login should be successful
    And I should see the forms dashboard
    And the sidebar menu should show the management option

  Scenario: Failed login with unregistered email
    When I attempt to log in with email "notfound@example.com" and password "any"
    Then the login should fail
    And I should see the error message "Invalid email/registration or password"

  Scenario: Failed login with incorrect password
    When I attempt to log in with email "user@gmail.com" and password "wrong1"
    Then the login should fail
    And I should see the error message "Invalid email/registration or password"
