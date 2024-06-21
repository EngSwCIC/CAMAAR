Feature: View Templates

    As a Coordinator
    I want to view the created templates
    So that I can edit and/or delete a template that I created

    Background:
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given that I created the teacher template "Template 1"
        Given that I created the student template "Template 2"
        And I am on the "Templates" page

    Scenario: Coordinator views created templates
        Then I expect to see the following:
            | name       |
            | Template 1 |
            | Template 2 |

        Then I expect to see the button "delete Template 1"
        Then I expect to see the link "edit Template 1"
        Then I expect to see the button "delete Template 2"
        Then I expect to see the link "edit Template 2"



    Scenario: No templates available
        Given that no templates have been created
        Then I expect to see "Não foram encontrados templates"