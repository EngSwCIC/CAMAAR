Feature: User, already registred, can change his password

    As a User
    I want to change my password from the email I recieved after requesting a password change
    So that I can use the website

Background:

    Given an User with name "Fulano de Tal" is already registred with email "fulano@detal.com" and password "ciclano"
    And I am on the login page
    
Scenario: User change his password

    And I press "Esqueceu sua senha?"
    Then I should be on the redefnition password page
    When I fill in "Email" with "fulano@detal.com"
    And I press "Enviar link de redefinição de senha"
    Then an email should be sent to "fulano@detal.com" containing a link
    When "fulano@detal.com" opens the email
    And user "fulano@detal.com" clicks on the link
    Then I should be on the definition password page
    And I should see "Fulano de Tal"
    When I fill in "Senha" with "teste123"
    And I fill in "Confirmar senha" with "teste123"
    And I press "Redefinir senha"
    Then I should see "Senha redefinida com sucesso."
    And trying to login with "fulano@detal.com" and "teste123" I should login

Scenario: User try to change his password, but his link expired