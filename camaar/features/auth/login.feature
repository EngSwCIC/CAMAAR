Feature: 

    As an User
    I want to access the system using an email or registration number and a previously set password
    So that I can respond to forms or manage the system

    Background: User has been added to the database

        Given that there are users in system
        Given the following user exists:

    Scenario Outline: User logs in with valid credentials
        Given I am on the "Login" page
        When I fill in the following:
            | email    | <email>    |
            | password | <password> |
        And I press the button "Entrar"
        Then I should be on the "Formulários" page

        And I should see "<name>"

        Examples:
            | email             | password | confirmation | name     |
            | student@gmail.com | 123456   | 123456       | John Doe |

        Scenario Outline: Admin logs in with valid credentials
        Given I am an unauthenticated Admin
        When I follow "Coordenador"
        Then I should see "Olá, coordenador!"
        When I fill in the following:
            | email   | password   |
            | <email> | <password> |
        And I press the button "Login"
        Then I should be on the page "Templates"
        And I should see "<name>"

        Examples:
            | email             | password | confirmation | name     |
            | admin@gmail.com | 123456   | 123456       | John Doe |
            
