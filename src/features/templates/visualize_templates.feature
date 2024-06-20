Feature: Visualize created templates

    As an admin
    I want to visualize the created templates 
    So that I can edit and/or delete a template that I have created

    Scenario: Visualizing an already created template
        Given I am on the Templates page
        When I click on the card of an already created template
        Then I should see the questions created for that template and its name

    Scenario: There are no templates created 
        Given that there are no created templates
        When I go to the Templates page
        Then I should see an empty page