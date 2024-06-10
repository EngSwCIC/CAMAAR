Feature: Sign up as a common user
    As an Student or Teacher
    I want to set a password for my account from the registration request email
    So that I can access the system

    Background: User has not been added to the database
        Given that I am an unregistered User

    Scenario: User has mismatched the password
        And I received a registration email at "testerror@gmail.com"
        When I click on registration link at "testerror@gmail.com"
        Then I expect to be on the "Cadastro de Usuário" page
        And I expect to see "Olá, Usuário!"
        And I expect to see "Defina sua senha"
        When I fill in the following:
            | password | 123456  |
            | password2| abc123 |
        When I click on "Confirmar"
        Then I expect to be on the "Root" page
        And I expect to not see "Senha"


    Scenario: User has clicked on the registration link
        And I received a registration email at "peluticaio@gmail.com"
        When I click on registration link at "peluticaio@gmail.com"
        Then I expect to be on the "Cadastro de Usuário" page
        And I expect to see "Olá, Usuário!"
        And I expect to see "Defina sua senha"
        When I fill in the following:
            | password | 123456  |
            | password2| 123456 |
        When I click on "Confirmar"
        And I received a confirmation email at "peluticaio@gmail.com"
        When I follow "Confirmar" at "peluticaio@gmail.com"
        Then I am on the "Users Login" page
        When I fill in the following:
            | email    | peluticaio@gmail.com |
            | password | 123456   |
        When I click on "Confirmar"
        Then I expect to be on the "User Camaar" page
        And I expect to see "Discente"
        And I expect to see "CIC"
        And I expect to see "Caio"


