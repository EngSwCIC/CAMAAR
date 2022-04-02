Feature: Filtrating a specific question.
    As a professor
    I want to see the data of a question from a certain evaluation
    So I could analyze my class perfomance

#HAPPY PATH
Scenario: The question is chosen.
    Given the data from the chosen evaluation is found
    And all the data is good to be used
    When the professor chooses a specific question
    Then the application should pass these data to the next step (Graph generation)
    And the results will be shown at the professor's screen.

#SAD PATH
Scenario: The question does not exist.
    Given there is no data for this question
    When the teacher chooses this question
    And the data is not found
    Then an alert message will be shown at the professor's screen
    And the results will not be shown at the professor's screen.

#SAD PATH
Scenario: The data is corrupted.
    Given there is corrupted data for this question
    When the teacher chooses this question
    And the data is found
    And the app is not able to filtrate some values
    Then an alert message will be shown at the professor's screen
    And the results will not be shown at the professor's screen.