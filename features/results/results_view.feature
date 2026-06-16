Feature: View form results

    Background:
        Given I am logged in as an admin user

    Scenario: View results for an answered form
        Given I navigate to the forms page
        And I have created a form called "Answered Form"
        And I click on the "Answered Form" form
        Then I should see the results for the "Answered Form" form

    Scenario: View results for a form with no answers
        Given I navigate to the forms page
        And I have created a form called "Unanswered Form"
        And I click on the "Unanswered Form" form
        Then I should see a message indicating that there are no results for the "Unanswered Form" form