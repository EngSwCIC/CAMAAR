Feature: User defines his password

    Me as a User
    I want to set a password for my user account from the registration request or redefnition request system email
    In order to access the system

Scenario: User already registred redefines his password

    Given "Fulano de Tal" with login "fulano@detal.com" and password "ciclano" solicitates password redefinition
    Then I should see "Fulano"
    When I fill in "Senha" with "teste123"
    And I fill in "Confirma a senha" with "teste123"
    And I press "Definir Senha"
    Then I should see "Deslogar"
    When I login with "fulano@detal.com" and "teste123"
    Then I should see "Deslogar"

Scenario: User already registred tries his old password

    Given "Fulano de Tal" with login "fulano@detal.com" and password "ciclano" solicitates password redefinition
    Then I should see "Fulano"
    When I fill in "Senha" with "teste123"
    And I fill in "Confirma a senha" with "teste123"
    And I press "Definir Senha"
    And I login with "fulano@detal.com" and "ciclano"
    Then I should see "Email ou senha inválidos"

Scenario: User not confirmed defines his password

    Given not confirmed user "Ciclano" with email "ciclano@dominio.com" click the definition link
    Then I should see "Ciclano"
    When I fill in "Senha" with "password"
    And I fill in "Confirma a senha" with "password"
    And I press "Definir Senha"
    When I login with "ciclano@dominio.com" and "password"
    Then I should see "Deslogar"

Scenario: User fill "Senha" with blank space

    Given "Fulano de Tal" with login "fulano@detal.com" and password "ciclano" solicitates password redefinition
    Then I should see "Fulano"
    When I fill in "Senha" with ""
    And I fill in "Confirma a senha" with ""
    And I press "Definir Senha"
    Then I should see "Defina sua senha nos espaços abaixo."

Scenario: New User fill "Confirmar Senha" with divergent password

    Given not confirmed user "Ciclano" with email "ciclano@dominio.com" click the definition link
    Then I should see "Ciclano"
    When I fill in "Senha" with "passdd"
    And I fill in "Confirma a senha" with "ddddss"
    And I press "Definir Senha"
    Then I should see "Password confirmation doesn't match Password"