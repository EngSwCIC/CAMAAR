Feature: Edit a form template
    As an Coordinator
    I want to edit a template without affecting forms that have already been sent
    So that I can organize existing templates effectively

    Background: I am an Coordinator
        Given I am an authenticated Coordinator
        When I follow "Templates"
        Then I should be on the page "Templates"
        Given that a template exists
        Then I should see "Template Teste"

    Scenario: Edit a Template
        When I press the button "edit_template"
        Then I should be on the route "templates/edit/0"
        And I fill in "template_name" with "Template Teste Novo"