#language: en
Feature: Allow professor to filter charts by classes
    As a Professor
    I want to filter a chart of questions by class
    So that I can view and analyze the answers of a form in a specific class

    # Happy path
    Scenario: Generate chart
        Given I am on the main charts visualization page
        And I have selected a question
        Then the application should show me the option to filter by class
        Then I should see the chart of that question filtered by class
        And the chart should show the answers only of that class

    # Sad path
    Scenario: Error in quering the database
        Given I am on the filtering page
        And I have selected a question
        And the application fails to retrieve the available classes for that question
        Then the application should send an error message to the user
        And the application should not generate a chart

    # Sad path
    Scenario: The question exists in that class but no one answered
        Given I am on the filtering page
        And I have selected a question and a class
        And the application returns empty data from the database
        Then the application should show an alert for the user
        And should not generate a chart
