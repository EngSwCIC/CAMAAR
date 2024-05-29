Feature: Registers students data on the system

    As a Coordinator
    I want to register participants data into the system
    So that they can create accounts on the CAMAAR system

    Scenario: Coordinator attempts to import class data

    Background: No data have been imported before
        Given I am an authenticated Coordinator
        And I am on the "Importar dados" page
        When I click on "Tipos de dados"
        And I choose "Turmas"
        Then I should be able to import the new class data

    Scenario: Coordinator attempts to import members data

    Background: No data have been imported before
        Given I am an authenticated Coordinator
        And I am on the "Importar dados" page
        When I click on "Tipos de dados"
        And I choose "Membros"
        Then I should be able to import the new members data
