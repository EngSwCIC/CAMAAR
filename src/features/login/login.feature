Feature: User can login with password and e-mail

    As an user (administrator or normal one)
    I want to login into the service
    So that I can use the website

Background:

    Given "Admin" with login "admin@admin.com" and password "admin" exists
    And "User" with login "user@user.com" and password "pass" exists
    And I am logged out
    And I am on the login page

Scenario: User admin trying to login
    
    When I fill in "E-mail" with "admin@localhost.com"
    And I fill in "Senha" with "admin"
    And I press "Entrar"
    Then I should see "Bem vindo, Admin"
    And the Admin home page

Scenario: User trying to login

    When I fill in "E-mail" with "user@user.com"
    And I fill in "Senha" with "pass"
    And I press "Entrar"
    Then I should see "Bem vindo, User"
    And the User home page

Scenario: Admin trying to login with a wrong password

    When I fill in "E-mail" with "admin@localhost.com"
    And i fill in "Senha" with "ADMIN"
    And I press "Entrar"
    Then I should see "E-mail e/ou senha não corresponde a nenhum usuário cadastrado."

Scenario: User trying to login with an invalid e-mail

    When I fill in "E-mail" with "admin"
    And I press "Entrar"
    Then I should see "Insira um e-mail válido."

Scenario: User fill "Senha" space with blank

    When I fill in "Senha" with ""
    And I fill in "E-mail" with "user@user.com"
    And I press "Entrar"
    Then I should see "Insira a senha"

Scenario: User trying to login with a wrong password

    When I fill in "E-mail" with "user@user.com"
    And I fill in "Senha" with "invalid"
    And I press "Entrar"
    Then I should see "E-mail e/ou senha não corresponde a nenhum usuário cadastrado."
