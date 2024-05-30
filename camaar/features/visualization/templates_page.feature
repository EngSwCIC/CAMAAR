Feature: View templates

    As a Coordinator
    I want to view the created templates
    So that I can edit and/or delete a template that I created
    
    Background:
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"

    Scenario: Coordinator tries to view created templates
        Given I follow "Templates"
        Then I should be on the "templates" page
        And I should be able to view the created templates
    
    Scenario: Coordinator tries to view a templates editing page
        Given I follow "Templates"
        Then I should be on the "templates" page
        Given that I created the template "Template 1"
        And I click the "Edit Template" button for "Template 1"
        Then I should be on the "Template 1" editing page
        And I should be able to view all the editing possibilities
    
    Scenario: Coordinator tries to view created templates after deleting a template
        Given I follow "Templates"
        Then I should be on the "templates" page
        Given that the template "Template 1" is available
        And I click on the "Delete Template" button for "Template 1"
        Then I should be able to view the created templates
        But the deleted template should not be visible