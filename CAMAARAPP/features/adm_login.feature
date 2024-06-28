Feature: User Login
    As a adm
    I want to log into my admin account
    So that I can access it

    Scenario: login
        Given I am on the login page
        Then I should see the login title
        When I enter my correct email
        When I enter my correct password
        When I click the Login button
        Then I should be redirected to gerenciamento
        And I should see a welcome message