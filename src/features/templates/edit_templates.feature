Feature: Edit and delete templates

    As an admin
    I want to edit and/or delete a template that I have created without affecting other created forms
    So that I can manage the existing templates

    Background:
        Given I am on the Templates page

    Scenario: Editing a form
        When I click on the edit icon
        And I change a question
        And I click on "Criar" button
        Them I should see an alert saying that the form has been successfully edited
        
    Scenario: Removing all the questions of a form
        When I click on the edit icon
        And I delete the name of the template
        And I click on "Criar" button
        Then I should see an alert saying that it is not possible to create a form without a name
        And the form should not be edited