Feature: User can login with password and e-mail

    As an user (administrator or normal one)
    I want to login into the service
    So that I can use the website

Background:

    Given "Admin" with login "admin@admin.com" and password "admin1" exists
    And "User" with login "user@user.com" and password "pass12" exists
    And I am logged out
    And I am on the login page

Scenario: User admin trying to login
    
    When I fill in "E-mail" with "admin@localhost.com"
    And I fill in "Senha" with "admin1"
    And I press "Entrar"
    Then I should see "Bem vindo(a), Admin!"

Scenario: User trying to login

    When I fill in "E-mail" with "user@user.com"
    And I fill in "Senha" with "pass12"
    And I press "Entrar"
    Then I should see "Bem vindo(a), User!"

Scenario: Admin trying to login with a wrong password

    When I fill in "E-mail" with "admin@localhost.com"
    And I fill in "Senha" with "ADMIN"
    And I press "Entrar"
    Then I should see "E-mail e/ou senha não corresponde a nenhum usuário cadastrado."

Scenario: User trying to login with an invalid e-mail

    When I fill in "E-mail" with "admin"
    And I press "Entrar"
    Then I should see "Insira um e-mail válido."

Scenario: User fill "Senha" with blank space

    When I fill in "Senha" with ""
    And I fill in "E-mail" with "user@user.com"
    And I press "Entrar"
    Then I should see "Insira a senha"

Scenario: User trying to login with a wrong password

    When I fill in "E-mail" with "user@user.com"
    And I fill in "Senha" with "invalid"
    And I press "Entrar"
    Then I should see "E-mail e/ou senha não corresponde a nenhum usuário cadastrado."
