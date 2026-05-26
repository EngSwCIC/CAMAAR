Feature: Login with email or registration number and admin menu display
  As a System User
  I want to log in with email or registration number and an already registered password
  So that I can answer forms or manage the system

  Note: When the logged-in user is an admin, the management option appears in the side menu.

  Background:
    Given I am on the CAMAAR login page

  Scenario: [Happy Path] Login with valid email
    Given a regular user exists with email "user@unb.br" and password "Senha123"
    When I fill the identification field with "user@unb.br"
    And I fill the password field with "Senha123"
    And I click the "Login" button
    Then I should be redirected to the CAMAAR dashboard

  Scenario: Login with valid registration number
    Given a user exists with registration number "200012345" and password "Senha123"
    When I fill the identification field with "200012345"
    And I fill the password field with "Senha123"
    And I click the "Login" button
    Then I should be redirected to the CAMAAR dashboard

  Scenario: Admin menu visible for admin
    Given an administrator exists with email "admin@unb.br" and password "AdminPass"
    When I fill the identification field with "admin@unb.br"
    And I fill the password field with "AdminPass"
    And I click the "Login" button
    Then I should see the "Management" option in the side menu

  Scenario: Admin menu hidden for regular user
    Given a regular user exists with email "user@unb.br" and password "Senha123"
    When I fill the identification field with "user@unb.br"
    And I fill the password field with "Senha123"
    And I click the "Login" button
    Then I should not see the "Management" option in the side menu

  Scenario: [Sad Path] Invalid credentials
    When I fill the identification field with "user@unb.br"
    And I fill the password field with "SenhaErrada"
    And I click the "Login" button
    Then I should see the error message "Identificação ou senha inválida"
