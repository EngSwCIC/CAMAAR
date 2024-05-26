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
        Then I should be on the page "Template 1"
        And I fill in "template_name" with "Template 1.1"
        When I press the button "save_template"
        Then I should see a confirmation popup
        When I confirm the popup
        Then I should be on the page "Templates"
        And I should see "Template 1.1"
