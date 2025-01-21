Feature: Create Template
    As a admin
    I want to create a template
    So that I can better manage the models

    Background: 
        Given I am on the template page
        When I press "+"
        Then I should go to the create template page

    Scenario: Create template
        When I fill in the "Nome" field with "Nome do Template"
        And I fill in the "Texto" field with "Descrição"
        And I press "Criar"
        Then I should go to the template page
        And I should see "Nome do Template"

    Scenario: Create template with missing fields
        When I press "Criar"
        Then I should see the error message "Fill in the fields" 
        And I should remain on the create template page  
        