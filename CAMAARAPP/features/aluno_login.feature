Feature: aluno login
    As a aluno
    I want to log in my account
    So that I can acces the website

    Scenario: aluno login
        Given I am on the login page
        Then I should see the login title
        When I enter my correct email
        When I enter my correct password
        When I click the Login button
        Then I should be redirected to home page
        And I should see a welcome message