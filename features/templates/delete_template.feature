Feature: Deleting a created template

    Background:
        Given I am logged in as an admin user
        And I am on the dashboard page
        And I have created a template with the name "Template Para Remover"

    Scenario: Delete template successfully
        When I navigate to the templates page
        And I click on the template named "Template Para Remover"
        And I click on "Delete"
        And I confirm the deletion
        Then I should see a confirmation message "Template removido com sucesso"
        And the list should not include "Template Para Remover"

    Scenario: Delete template without affecting already created forms
        Given I have created a form from the template "Template Para Remover"
        When I navigate to the templates page
        And I click on the template named "Template Para Remover"
        And I click on "Delete"
        And I confirm the deletion
        Then I should see a confirmation message "Template removido com sucesso"
        And the form created from "Template Para Remover" should still exist

    Scenario: Cancel template deletion
        When I navigate to the templates page
        And I click on the template named "Template Para Remover"
        And I click on "Delete"
        And I cancel the deletion
        Then the list should include "Template Para Remover"
