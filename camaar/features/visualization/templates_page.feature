Feature: View Templates

    As a Coordinator
    I want to view the created templates
    So that I can edit and/or delete a template that I created.
    
    Background:
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        And I follow "Templates"
        Then I should be on the "templates" page.

    Scenario: Coordinator Views Created Templates
        Given I am on the "Templates" page
        Then I should be able to view the created templates.

    Scenario: Coordinator Views A Templates Editing Page
        Given that I created the template "Template 1"
        And I click the "Edit Template" button for "Template 1"
        Then I should be on the "Template 1" editing page
        And I should be able to view the editing possibilities.
    
    Scenario: Coordinator Views Created Templates After Deleting A Template
        Given that there is template "Template 1" 
        And I click on the "Delete Template" button for "Template 1"
        Then I should be able to view the created templates
        But the "Template 1" template should not be there.
    
    Scenario: Coordinator Logs Out
        Given I am on "Admin Camaar" page
        And I click on "Sair"
        Then I  should be redirected to the "Root" page.