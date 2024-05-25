Feature: Login

    As a User
    I want to access the system using an email or registration number and a previously set password
    So that I can respond to forms or manage the system

    Background: User has been added to the database
        Given that there are users in system

        Given the following user exists:

    Scenario Outline: User logs in with valid credentials
        Given I am on the page "login"
        When I fill in the following:
            | email    | <email>    |
            | password | <password> |
        And I press the button "login"
        Then I should be on the page "forms"
        And I should see "<name>"

        Examples:
            | email              | password | name                   |
            | acjpjvjp@gmail.com | 123456   | Ana Clara Jordao Perna |
