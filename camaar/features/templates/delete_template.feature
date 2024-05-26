Feature: Delete a form template
    As an Coordinator
    I want to delete a template without affecting forms that have already been sent
    So that I can organize existing templates effectively


    Background: I am an Coordinator
        Given I am an authenticated Coordinator
        When I follow "Templates"
        Then I should be on the page "Templates"
        Given that a template exists
        Then I should see "Template Teste"

    Scenario: Deleting a template
        When I press the button "delete_template"
        Then I should see a confirmation popup
        And I confirm the popup
        Then I should not see "Template Teste"
