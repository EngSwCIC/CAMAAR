Feature: Delete a form template
    As an Coordinator
    I want to delete a template without affecting forms that have already been sent
    So that I can organize existing templates effectively

    Scenario: Edit a Template
        Given I am logged in
        And I am on the Camaar home page
        When I click 'Templates' on menu
        Then I should be on Templates page
        When I see "Newest Template"
        And I click "delete"
        Then I should not see "Newest Template" on Templates page
        When I see "Older Template"
        And I click "edit"
        Then I should be on Edit Page
        When I see "Avalie CIC0190"
        And I click "edit"
        And I fill in "Avalie MAT0053"
        Then I should see "Avalie MAT0053"
        When I see "Older Template"
        And I click "edit"
        And I fill in "New Template"
        And I press "enviar"
        Then I should be on Templates page
        And I should see "New Template"
