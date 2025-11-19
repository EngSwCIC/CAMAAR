Feature: Database Update
    As an Administrator
    I want to update the existing database with current SIGAA data
    In order to correct the system database

    Background:
        Given that I am logged in as an administrator

    Scenario: Successfully update database with SIGAA data
        Given that I am on the Gerenciamento page
        When I click on "Importar Database"
        And the system connects to SIGAA successfully
        Then I should see "Database update started"
        And the system should synchronize data from SIGAA
        Then I should see "Database updated successfully"
        And the database should contain the latest SIGAA data

    Scenario: Verify updated data in database
        Given that the database was updated with SIGAA data
        When I access the database management page
        Then I should see updated student records
        And I should see updated class records
        And I should see updated enrollment records
        And the data should match the current SIGAA data

    Scenario: Update database with connection error to SIGAA
        Given that I am on the Gerenciamento page
        When I click on "Importar Dados"
        And the system cannot connect to SIGAA
        Then I should see "Error connecting to SIGAA"
        And the database should remain unchanged
        And I should see an option to retry the connection

    Scenario: Update database when already up to date
        Given that the database was recently updated
        And the database is already synchronized with SIGAA
        When I click on "Importar Dados"
        Then I should see "Database is already up to date"
        And no data should be modified

    Scenario: Update database without administrator permissions
        Given that I am logged in as a regular user
        When I try to access the database update page
        Then I should see "Access denied"
        And I should be redirected to the home page

    Scenario: Partial update when some SIGAA data is unavailable
        Given that I am on the database update page
        When I click on "Update Database"
        And some SIGAA data is temporarily unavailable
        Then I should see "Partial update completed"
        And the available data should be updated
        And I should see a warning about unavailable data

