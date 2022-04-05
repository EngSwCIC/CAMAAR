#language: en
Feature: Generate chart for filtered question
    As a Professor
    I want to generate a chart for a filtered question
    So that I can visualize the opinions of students regarding the question

    # Happy path
    Scenario: Generate chart
        Given I am on the filtering page
        And I have selected a question
        Then the application should look in the database for the question data
        Then the application should send the data to the chart generator
        Then I should see a chart be generated right below the selection field
        And the chart should contain the data of the selected question

    # Sad path
    Scenario: Error in quering the database
        Given I am on the filtering page
        And I have selected a question
        And the application fails to retrieve the data from the database
        Then the application should send an error message to the user
        And the application should not generate a chart

    Scenario: Incompatible data
        Given I am on the filtering page
        And I have selected a question
        Then the application should look in the database for the question data
        Then the application should send the data to the chart generator
        Then the chart generator should fail in generating the chart
        Then the application should send an error message to the user
        And the application should not generate a chart
