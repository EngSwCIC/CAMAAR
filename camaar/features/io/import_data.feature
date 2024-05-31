Feature: Registers students data on the system

    As a Coordinator
    I want to register participants data into the system
    So that they can create accounts on the CAMAAR system

    Background: No data has been imported before
        Given I am an authenticated Coordinator from the ""
        And I am on the "Importar dados" page
        When I click on "Tipos de dados"


    Scenario: Coordinator imports classes data
        And I choose "Turmas"
        When I click "Upload"
        And I choose a json file with the classes data
        When I click "Importar"
        Then I should be see "Dados das turmas importados com sucesso"
        When I go to the "Turmas" page
        Then I shoud see the following classes:
            #TODO
            | name | subject | classCode | semester | time |
            |      |         |           |          |      |
            
    Scenario: Coordinator imports members data
        And I choose "Membros"
        And I click "Upload"
        And I choose a json file with the members data
        When I click "Importar"
        Given the following class exists:
            #TODO
            | name    | subject | classCode | semester | time |
            | CIC0097 |         |           |          |      |
        Then I should be see "Dados dos alunos importados com sucesso"
        When I go to the "Turmas" page
        Then I shoud see the following classes:
            #TODO
            | name | subject | classCode | semester | time |
            |      |         |           |          |      |
        When I follow "2021.2_CIC0197_TA"
        Then I should be on the "2021.2/CIC0197/TA" page
        And I should see "MARISTELA TERTO DE HOLANDA"
        And I should see "William Xavier dos Santos"
