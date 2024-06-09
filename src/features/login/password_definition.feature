Feature: User defines his password

    Me as a User
    I want to set a password for my user account from the registration request or redefnition request system email
    In order to access the system

Scenario: User already registred redefines his password

    Given "Fulano" is already registred with email "fulano@detal.com" and password "ciclano"
    And solicitates password redefnition
    Then I should see "Fulano" on password definition page
    When I fill in "Senha" with "teste123"
    And I fill in "Confirmar senha" with "teste123"
    And I press "Definir senha"
    Then I should see "Senha definida com sucesso."
    And trying to login with "fulano@detal.com" and "teste123"
    Then I should see "Bem vindo, Fulano."

Scenario: User already registred tries his old password

    Given "Fulano" is already registred with email "fulano@detal.com" and password "pass"
    And solicitates password redefnition
    Then I should see "Fulano" on password definition page
    When I fill in "Senha" with "teste123"
    And I fill in "Confirmar senha" with "teste123"
    And I press "Definir senha"
    Then I should see "Senha definida com sucesso."
    And trying to login with "fulano@detal.com" and "pass"
    Then I should see "E-mail e/ou senha não corresponde a nenhum usuário cadastrado."

Scenario: User not registred defines his password

    Given not registred user "Ciclano" with email "ciclano@dominio.com" exists
    And recieved an email with a link for registration in the system
    Then I should see "Ciclano" on password definition page
    When I fill in "Senha" with "pass"
    And I fill in "Confirmar Senha" with "pass"
    And I press "Definir Senha"
    Then I should see "Senha definida com sucesso."
    And trying to login with "ciclano@dominio.com" and "pass"
    Then I should see "Bem vindo, Ciclano"
    And I should see the User home page

Scenario: User fill "Senha" with blank space

    Given "Fulano" is already registred with email "fulano@detal.com" and password "pass"
    And solicitates password redefnition
    Then I should see "Fulano" on password definition page
    When I fill in "Senha" with ""
    And I fill in "Confirmar senha" with ""
    And I press "Definir senha"
    Then I should see "Preencha corretamente o campo de senha"

Scenario: New User fill "Confirmar Senha" with divergent pass

    Given not registred user "Ciclano" with email "ciclano@dominio.com" exists
    And recieved an email with a link for registration in the system
    Then I should see "Ciclano" on password definition page
    When I fill in "Senha" with "pass"
    And I fill in "Confirmar Senha" with "dddd"
    And I press "Definir Senha"
    Then I should see "As senhas não correspondem. Preenha os campos corretamente."

Scenario: User click an invalid link

    Given "Fulano" is already registred with email "fulano@detal.com" and password "ciclano"
    And click an invalid link for password redefinition
    Then I should see "O link que tentou utilizar expirou."