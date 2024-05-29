Feature: Administrator can update SIGAA Data

    As an administrator
    I want to go to the management page
    So that I can update the data from SIGAA, keeping the functionalities up-to-date

Background: 

    Given I am an admin on the management webpage
    And the data import option is available
  
Scenario: Successful data update

    When I import the new SIGAA data from an external source
    Then the data should be updated successfully
    And the remaining options should continue to be available

Scenario: Failed data update due to unsupported file format

    When I attempt to import the new SIGAA data from an external source
    And the import fails due to an unsupported file format
    Then an error message should be displayed indicating an unsupported file format
    And the remaining options should continue to be available

Scenario: Incorrect or corrupted new SIGAA data

    When I attempt to import the new SIGAA data from an external source
    Then a data import error message should be displayed
    And the remaining options should continue to be available