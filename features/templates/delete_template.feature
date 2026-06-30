Feature: Deleting a created template

    Background:
        Given I am logged in as an admin user
        And I am on the dashboard page
        And I have created a template with the name "Template Para Remover"

    Scenario: Delete template successfully
        When I navigate to the templates page
        And I check the checkbox to remove the template named "Template Para Remover"
        And I click the button "Confirmar exclusão" on the template named "Template Para Remover"
        Then the user should not see "Template Para Remover"
        Then I should see a confirmation message "Template removido com sucesso"
        And the user should not see "Template Para Remover"

    Scenario: Cancel template deletion
        When I navigate to the templates page
        And I do not check the checkbox to remove the template named "Template Para Remover"
        And I click the button "Confirmar exclusão" on the template named "Template Para Remover"
        Then the user should see "Template Para Remover"
