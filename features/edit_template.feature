Feature: Edit Templates

    As an admin,
    I want to manage my form templates,
    So that I can make different types of forms.

    Background:
        Given I am logged in as an admin user 
        And the stored data is up to date
	And I am on the templates page

    Scenario: Edit a valid template
	Given I have a template with name "Template 1"
	When I click "Visualizar template"
	And I click "Editar template"
 	And I fill "Título" with "Template 2"
   	And I click "Criar template"
    	Then I should see "Template atualizado com sucesso."
     	And I should see "Template 2"

    Scenario: Edit an invalid template
	Given I have a template with name "Template 1"
	When I click "Visualizar template"
	And I click "Editar template"
 	And I fill "Título" with ""
    	Then I should see "1 erro imperdiram o template de ser salvo"

    Scenario: Delete a template
	Given I have a template with name "Template 1"
	When I click "Visualizar template"
	And I click "Deletar template"
	Then I should be on the templates page
 	And I should see no templates
