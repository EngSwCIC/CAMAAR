Feature: View Templates

    As a Coordinator
    I want to view the created templates
    So that I can edit and/or delete a template that I created.
    
    Background:
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        And I follow "Templates"
        Then I should be on the "templates" page.

    Scenario: Coordinator Views Created Templates
        Given I am on the "templates" page
        Then I should be able to view the created templates.
    
    Example: 
        Given "Template 1" was created:

        Then I should see the following resources:
        |                                  | | Template 1                                          |
        |                 +                | | <class_classCode> - <class_semester> - <class_code> | 
        |                                  | | <class_teacher>                                     |

    Scenario: Coordinator Views A Templates Editing Page
        Given that I created the template "Template 1"
        And I click the "Edit Template" button for "Template 1"
        Then I should be on the "Template 1" editing page
        And I should be able to view all the editing possibilities.
    
    Scenario: Coordinator Views Created Templates After Deleting A Template
        Given that the template "Template 1" is available
        And I click on the "Delete Template" button for "Template 1"
        Then I should be able to view the created templates
        But the deleted template should not be visible.
    
    Example: 
        Given "Template 1" was the only created template

        And it got deleted right away

        Then I should see the following resources:
        |                                  |
        |                 +                |
        |                                  |
    
    Scenario: Coordinator Logs Out
        Given I log out by clicking on the "Sair" button
        Then I should no longer see any templates
        And should be redirected to the login page.