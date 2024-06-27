Feature: User Logout
    As a user
    I want to log out of my account
    So that I can leave the website

    Scenario: login
        Given I am on the user page
        And I click the Logout button
        Then I should be redirected to home page
