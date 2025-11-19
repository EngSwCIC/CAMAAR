Feature: Login System
    As a System User
    I want to access the system using an email or registration number and a registered password
    In order to answer forms or manage the system

    Scenario: Login with valid credentials
    Given that I am on the login page
    When I fill in the "email" field with "usuario@example.com"
    And I fill in the "password" field with "senha123"
    And I click on "Entrar"
    Then I should be on the evaluations page

    Scenario: Login with invalid email
    Given that I am on the login page
    When I fill in the "email" field with "invalido@example.com"
    And I fill in the "password" field with "senha123"
    And I click on "Entrar"
    Then I should see "Invalid email or password"

    Scenario: Login with invalid password
    Given that I am on the login page
    When I fill in the "email" field with "usuario@example.com"
    And I fill in the "password" field with "senhainvalida123"
    And I click on "Entrar"
    Then I should see "Invalid email or password"