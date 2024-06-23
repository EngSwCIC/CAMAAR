Feature: Visualize Templates

    As an admin,
    I want to visualize my form templates,
    So that I can verify what templates I have.

    Background:
        Given I am logged in as an admin user 
        And the stored data is up to date
	    And I am on the templates page

    Scenario: There are templates to be seen
        Given I have a template with name "Template 1"
        Then I should see "Template 1"

    Scenario: There are no templates to be seen
        Given I have no templates
        Then I should see "Novo Template"

    Scenario: Visualizing a template
        Given I have a template with name "Template 1"
        When I click "Visualizar template"
        Then I should see "Título: Template 1"
        And I should see "Editar template"
        And I should see "Deletar template"
        And I should see "Voltar"
