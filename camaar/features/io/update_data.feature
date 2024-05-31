Feature: Update database data

    As a Coordinator
    I want to update the existing database with the current data from SIGAA
    So that I can correct the system's database

    Background: Data has already been imported before
        Given I am an authenticated Coordinator from ""
        Given that I already imported the classes data
        Given that I already imported the members data

        Given that on SIGAA the student "William Xavier dos Santos" left the class "2021.2-CIC0097-TA"
        Given that on SIGAA the class "2021.2-CIC0097-TA" was updated with:
            | name | subject | classCode | semester | time |
            |      |         |           |          |      |
        And I am on the "Importar dados" page

    Scenario: Coordinator attempts to update class data
        And I choose "Turmas"
        When I click "Upload"
        And I choose a json file with the updated classes data
        When I click "Importar"
        Then I should be see "Dados das turmas importados com sucesso"
        When I go to the "Turmas" page
        Then I shoud see the following classes:
            #TODO copiar da outra feature de view
            |  |
    Scenario: Coordinator attempts to update members data
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
        And I should not see "William Xavier dos Santos"
