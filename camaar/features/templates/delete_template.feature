Feature: Delete a form template
    As an Coordinator
    I want to delete a template without affecting forms that have already been sent
    So that I can organize existing templates effectively


    Background: I am an Coordinator
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given I am on the "Templates" page
        Given I created the template "Template 1"

    Scenario: Deleting a template
        When I follow "Template 1"
        Then I expect to be on the "Template 1" page
        And I expect to see "Excluir"
        # When I press "Delete"
        When I delete the template
        Then I expect to be on the "Templates" page
        Then I should not see "Template 1"

    Scenario: Template was already deleted on another page
        Then I should see "Não foi possível encontrar o template"
        Then I should be on the "Templates" page
        Then I should not see "Template 1"

