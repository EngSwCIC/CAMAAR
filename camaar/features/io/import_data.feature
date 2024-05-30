Feature: Registers students data on the system

    As a Coordinator
    I want to register participants data into the system
    So that they can create accounts on the CAMAAR system

    Background: No data has been imported before

    Scenario: Coordinator attempts to import class data
        Given I am an authenticated Coordinator
        And I am on the "Importar dados" page
        When I click on "Tipos de dados"
        And I choose "Turmas"
        And I click "Upload"
        And I choose a json file
        And I click "Importar"
        Then I should be able to import the new class data

    Scenario: Coordinator attempts to import members data
        Given I am an authenticated Coordinator
        And I am on the "Importar dados" page
        When I click on "Tipos de dados"
        And I choose "Membros"
        And I click "Upload"
        And I choose a json file
        And I click "Importar"
        Then I should be able to import the new members data
