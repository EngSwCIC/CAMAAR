Feature: User Login
    As a user
    I want to log into my student or admin account
    So that I can access it

    Scenario: login
        Given I am on the login page
        When I enter my correct email and password
        And I click the "Login" button
        Then I should be redirected to "user_home"
        And I should see a welcome message with my name