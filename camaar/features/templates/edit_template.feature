Feature: Edit a form template
    As an Coordinator
    I want to edit a template without affecting forms that have already been sent
    So that I can organize existing templates effectively

    Scenario: Edit a Template
        Given I am logged in
        And I am on the Camaar home page
        When I click 'Templates' on menu
        Then I should be on Templates page
        When I see "Newest Template"
        And I press the button "delete"
        Then I should not see "Newest Template" on Templates page
        When I see "Older Template"
        And I press the button "edit"
        Then I should be on Edit Page
        When I see "Avalie CIC0190"
        And I press the button "edit"
        And I fill in "Avalie MAT0053"
        Then I should see "Avalie MAT0053"
        When I see "Older Template"
        And I press the button "edit"
        And I fill in "New Template"
        And I press "enviar"
        Then I should be on Templates page
        And I should see "New Template"
