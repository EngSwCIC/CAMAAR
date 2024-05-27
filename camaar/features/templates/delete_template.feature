Feature: Delete a form template
    As an Coordinator
    I want to delete a template without affecting forms that have already been sent
    So that I can organize existing templates effectively


    Background: I am an Coordinator
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Templates"
        Then I should be on the page "Templates"
        Given that I created the template "Template 1"
        Then I should see "Template 1"
        When I press the button "Deletar Template"
        And I confirm a popup

    Scenario: Deleting a template
        Then I should be on the page "Templates"
        Then I should not see "Template 1"

    Scenario: Template was deleted on another page
        Then I should see "Não foi possível encontrar o template"
        Then I should be on the page "Templates"
        Then I should not see "Template 1"

