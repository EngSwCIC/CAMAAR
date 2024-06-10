Feature: Create Template

    As an admin,
    I want to create a new template,
    So that I can manage my forms.

    Background:
        Given I am logged in as an admin user 
        And the stored data is up to date
        And I am on the templates page

    Scenario: Create a valid template
        Given I have no templates
        When I click "Novo template"
      	And I fill "Título" with "Template 1"
      	And I choose "Texto" for "Tipo"
      	And I fill "Questão" with "Quanto é 2+2?"
      	And I click "Criar template"
        Then I should be on the templates page
      	And I should see "Template criado com sucesso."
      	And I should see "Template 1"	

    Scenario: Create an invalid template	
      	Given I have no templates
        When I click "Novo template"
      	And I click "Criar template"
      	Then I should see "erros imperdiram o template de ser salvo"
