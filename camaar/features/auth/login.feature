Feature:
    As an User
    I want to access the system using an email or registration number and a previously set password
    So that I can respond to forms or manage the system

    Scenario Outline: User logs in with valid credentials
        Given that I am an unauthenticated User
        Given I am on the "Login de Usuário" page
        When I fill in the following:
            | email          | password |
            | user@gmail.com | 123456   |
        And I press the button "Entrar"
        Then I should be on the "Formulários" page
        And I should see "John Doe"


    Scenario Outline: Admin logs in with valid credentials
        Given that I am an unauthenticated Admin
        When I follow "Coordenador"
        Then I should see "Olá, coordenador!"
        When I fill in the following:
            | email   | password   |
            | <email> | <password> |
        And I press the button "Login"
        Then I should be on the "Templates" page
        And I should see "<name>"

        Examples:
            | email           | password | confirmation | name     |
            | admin@gmail.com | 123456   | 123456       | John Doe |

