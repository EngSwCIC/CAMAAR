Feature: Delete a form template
    As an Coordinator
    I want to delete a template without affecting forms that have already been sent
    So that I can organize existing templates effectively


    Background: I am an Coordinator
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Templates"
        Then I should be on the "Templates" page
        Given that I created the following templates:
            | Template 1 | teacher |
        Then I should see "Template 1"
        When I press "Deletar Template"
        And I confirm a popup

    Scenario: Deleting a template
        Then I should be on the "Templates" page
        Then I should not see "Template 1"

    Scenario: Template was already deleted on another page
        Then I should see "Não foi possível encontrar o template"
        Then I should be on the "Templates" page
        Then I should not see "Template 1"

