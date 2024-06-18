Feature: Delete a form template
    As an Coordinator
    I want to delete a template without affecting forms that have already been sent
    So that I can organize existing templates effectively


    Background: I am an Coordinator
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given I am on the "Templates" page
        Given that I created the student template "Template 1"
        When I follow "Template 1"
        Then I expect to be on the "Template 1" page

    Scenario: Deleting a template
        And I expect to see "Excluir"
        When I press "Delete"
        Then I expect to be on the "Templates" page
        Then I expect to not see "Template 1"


    Scenario: Template was already deleted on another page
        Given that "Template 1" was deleted
        When I press "Delete"
        Then I expect to be on the "Templates" page
        Then I expect to see "Não foi possível encontrar o template"
        Then I expect to not see "Template 1"

