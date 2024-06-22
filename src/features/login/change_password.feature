Feature: User, already registred, can change their password

    As a User
    I want to change my password using the email I received after requesting a password change
    So that I can use the website

Background:
    Given "Fulano de Tal" with login "fulano@detal.com" and password "ciclano" exists
    And I am logged out
    And I am on the login page

Scenario: User changes their password
    When I click "Esqueceu sua senha?" link
    Then I should be on the password redefinition page
    When I fill in "Email" with "fulano@detal.com"
    And I press "Me mande as instruções de redefinição de senha"
    When "fulano@detal.com" opens the email
    Then an email should be sent to "fulano@detal.com" containing a link
    When I click "Definir Senha" email link
    Then I should be on the password definition page
    And I should see "Fulano De Tal"

Scenario: User tries to change their password, but their email is wrong
    When I click "Esqueceu sua senha?" link
    Then I should be on the password redefinition page
    When I fill in "Email" with "ciclano@detal.com"
    And I press "Me mande as instruções de redefinição de senha"
    Then I should see "Email not found"

Scenario: User fills in email with blank space
    When I click "Esqueceu sua senha?" link
    Then I should be on the password redefinition page
    When I fill in "Email" with ""
    And I press "Me mande as instruções de redefinição de senha"
    Then I should see "Email can't be blank"