Feature: Editing a created template

    Background:
        Given I am logged in as an admin user
        And I am on the dashboard page
        And I have created a template with the name "Template Antigo"

    Scenario: Edit template name successfully
        When I navigate to the templates page
        And I click on the template named "Template Antigo"
        And I click on "Edit"
        And I change the template name to "Template Novo"
        And I click on "Save"
        Then I should see a confirmation message "Template atualizado com sucesso"
        And the list should include "Template Novo"

    Scenario: Edit template questions without affecting existing forms
        Given I have created a form from the template "Template Antigo"
        When I navigate to the templates page
        And I click on the template named "Template Antigo"
        And I click on "Edit"
        And I add a question "Qual sua avaliação geral?"
        And I click on "Save"
        Then I should see a confirmation message "Template atualizado com sucesso"
        And the existing form created from "Template Antigo" should remain unchanged

    Scenario: Cancel template editing
        When I navigate to the templates page
        And I click on the template named "Template Antigo"
        And I click on "Edit"
        And I change the template name to "Template Cancelado"
        And I click on "Cancel"
        Then the list should include "Template Antigo"
        And the list should not include "Template Cancelado"
