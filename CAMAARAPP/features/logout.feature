Feature: User Logout
    As a user
    I want to log out of my account
    So that I can leave the website

    Scenario: Logout
        Given I am loged in
        Given I am on the gerenciamento page
        When I click the Logout button
        Then I should be redirected to the home page
