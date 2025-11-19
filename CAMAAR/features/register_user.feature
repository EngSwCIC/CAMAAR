Feature: Register User as Admin

    Scenario: Registration email is sent by importing new user data
        Given I am admin
        And I am on the "gerenciamento" page
        And there is an importable user
        And I have clicked on the "Importar dados" button
        When the data is imported
        Then a registration email should be sent to the user's email

    Scenario: Email is not sent when user data import fails
        Given I am admin
        And I am on the "gerenciamento" page
        And there is an importable user
        And I have clicked on the "Importar dados" button
        When the data import fails
        Then no registration email should be sent
        And I should see an error message indicating the import failed

    Scenario: Email is not sent when imported user has an invalid email
        Given I am admin
        And I am on the "gerenciamento" page
        And there is an importable user with an invalid email address
        And I have clicked on the "Importar dados" button
        When the data is imported
        Then no registration email should be sent
        And I should see an error message indicating the email is invalid