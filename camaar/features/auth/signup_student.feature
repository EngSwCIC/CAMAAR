Feature: Sign up as a common user
    As an Student or Teacher
    I want to set a password for my account from the registration request email
    So that I can access the system

    Background: User has not been added to the database
        Given that I am an unregistered User

    Scenario: User has mismatched the password
        And I received a registration email at "testerror@gmail.com"
        When I click on registration link at "testerror@gmail.com"
        Then I should be on the "Cadastro de Usuário" page
        And I should see "Olá, Usuário!"
        And I should see "Defina sua senha"
        When I fill in the following:
            | password | 123456  |
            | password2| abc123 |
        When I press "Confirmar"
        Then I should be on the "Root" page
        And I should not see "Senha"


    Scenario: User has clicked on the registration link
        And I received a registration email at "test@gmail.com"
        When I click on registration link at "test@gmail.com"
        Then I should be on the "Cadastro de Usuário" page
        And I should see "Olá, Usuário!"
        And I should see "Defina sua senha"
        When I fill in the following:
            | password | 123456  |
            | password2| 123456 |
        When I press "Confirmar"
        And I received a confirmation email at "test@gmail.com"
        When I follow "Confirmar" at "test@gmail.com"
        Then I am on the "Users Login" page
        When I fill in the following:
            | email    | test@gmail.com |
            | password | 123456   |
        When I press "Confirmar"
        Then I should be on the "User Camaar" page
        And I should see "Usuário"
        And I should see "test@gmail.com"


