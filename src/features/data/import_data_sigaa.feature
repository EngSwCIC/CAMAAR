Feature: Administrator can import SIGAA Data

    As an administrator
    I want to go to the management page
    So that I can import data from SIGAA, unlocking the other functionalities

Background: 

    Given I am an admin on the management webpage
    And the data import option is available

Scenario: Successful data import

    When I import the SIGAA data from an external source
    Then the data should be imported successfully
    And the remaining options should be available

Scenario: Failed data import

    When I attempt to import the SIGAA data from an external source
    And the import fails
    Then an error message should be displayed
    And the remaining options should not be available

Scenario: Incorrect or corrupted SIGAA data

    When I attempt to import the SIGAA data from an external source
    Then a data import error message should be displayed
    And the remaining options should not be available