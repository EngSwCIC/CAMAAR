Feature: User, already registred, can change their password

    As a User
    I want to change my password using the email I received after requesting a password change
    So that I can use the website

Background:
    Given "Fulano de Tal" is already registred with the email "fulano@detal.com" and password "ciclano"
    And I am on the login page

Scenario: User changes their password
    When I press "Esqueceu sua senha?"
    Then I should be on the password redefinition page
    When I fill in "Email" with "fulano@detal.com"
    And I press "Enviar link de redefinição de senha"
    Then an email should be sent to "fulano@detal.com" containing a link
    When "fulano@detal.com" opens the email
    And user "fulano@detal.com" clicks on the link
    Then I should be on the password definition page
    And I should see "Fulano de Tal"

Scenario: User tries to change their password, but their email is wrong
    When I press "Esqueceu sua senha?"
    Then I should be on the password redefinition page
    When I fill in "Email" with "ciclano@detal.com"
    And I press "Enviar link de redefinição de senha"
    Then I should see "O e-mail não está associado a nenhuma conta."

Scenario: User fills in email with blank space
    When I press "Esqueceu sua senha?"
    Then I should be on the password redefinition page
    When I fill in "Email" with ""
    And I press "Enviar link de redefinição de senha"
    Then I should see "Preencha o e-mail corretamente"