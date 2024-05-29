Feature: Visualize created templates

    As an admin
    I want to visualize the created templates 
    So that I can edit and/or delete a template that I have created

    Background:
        Given I am on the Templates page

    Scenario: Visualizing an already created template
        When I click on the card of an already created template
        Then I should see the questions created for that template and its name

    Scenario: Removing all the questions of a form
        When I click on the edit icon
        And I delete all questions
        And I click on "Criar" button
        Them I should see an alert saying that it is not possible to create an empty form
        And the form should not be edited