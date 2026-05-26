Feature: Searching templates

    Background:
        Given I am logged in as an admin user
        And I am on the dashboard page

    Scenario: Search for an existing template
        Given I have created a template with the name "Algorithms Evaluation"
        And I have created a template with the name "Satisfaction Survey"
        When I navigate to the templates page
        And I search for "Algorithms" in the search bar
        Then I should see "Algorithms Evaluation" in the list
        And I should not see "Satisfaction Survey" in the list

    Scenario: Search for a non-existent template
        Given I have created a template with the name "Algorithms Evaluation"
        And I have created a template with the name "Satisfaction Survey"
        When I navigate to the templates page
        And I search for "Calculus" in the search bar
        Then I should not see any templates in the list
        And I should see the message "[ Nenhum template encontrado ]"
