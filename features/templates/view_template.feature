Feature: Viewing created templates

    Background:
        Given I am logged in as an admin user
        And I am on the dashboard page

    Scenario: View created templates
        Given I have created a template with the name "Template 1"
        And I have created a template with the name "Template 2"
        When I navigate to the templates page
        Then I should see a list of created templates
        And the list should include "Template 1"
        And the list should include "Template 2"

    Scenario: View template details
        Given I have created a template with the name "Template 1"
        When I navigate to the templates page
        And I click on the template named "Template 1"
        Then I should see the details of "Template 1"
        And the details should include the name "Template 1"
