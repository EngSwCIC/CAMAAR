Feature: Login with email or registration number and admin menu display
  As a System User
  I want to log in with email or registration number and an already registered password
  So that I can answer forms or manage the system

  Note: When the logged-in user is an admin, the management option appears in the side menu.

  Background:
    Given the user is on the login page

  Scenario: [Happy Path] Login with valid email
    Given there is a user with email "user@unb.br" and password "Senha123"
    And the user is on the login page
    When the user fills "user@unb.br" in the username field
    And the user fills "Senha123" in the password field
    And the user clicks "Log in" button
    Then the user should be redirected to the dashboard

  Scenario: Admin menu visible for admin
    Given there is an administrator with email "admin@unb.br" and password "AdminPass"
    When the user fills "admin@unb.br" in the username field
    And the user fills "AdminPass" in the password field
    And the user clicks "Log in" button
    Then the user should see "Templates"

  Scenario: Admin menu hidden for regular user
    Given there is a user with email "user@unb.br" and password "Senha123"
    When the user fills "user@unb.br" in the username field
    And the user fills "Senha123" in the password field
    And the user clicks "Log in" button
    Then the user should not see "Templates"

  Scenario: [Sad Path] Invalid credentials
    When the user fills "user@unb.br" in the username field
    And the user fills "SenhaErrada" in the password field
    And the user clicks "Log in" button
    Then I should see the message "Invalid email or password"
