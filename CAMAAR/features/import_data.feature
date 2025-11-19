Feature: Import Data from SIGAA as Admin

    Scenario: Admin imports data
        Given I am admin
        And I am on "gerenciamento" page
        And there is importable data
        When I click on "Importar dados" button
        Then the importable data should be imported

    Scenario: Admin tries to import data when none is available
        Given I am admin
        And I am on "gerenciamento" page
        And there is no importable data
        When I click on "Importar dados" button
        Then I should see a message indicating that no data is available to import
        And no data should be imported
    
    Scenario: Import fails due to invalid data format
        Given I am admin
        And I am on the "gerenciamento" page
        And there is importable data with an invalid format
        When I click on the "Importar dados" button
        Then I should see an error message indicating the data format is invalid
        And the import should be aborted

    Scenario: Import partially succeeds but some data is invalid
        Given I am admin
        And I am on the "gerenciamento" page
        And there is importable data with some invalid data
        When I click on the "Importar dados" button
        Then the valid data should be imported
        And I should see a warning indicating that some data could not be imported