Feature: Update database data

    As a Coordinator
    I want to update the existing database with the current data from SIGAA
    So that I can correct the system's database

    Background: Data has already been imported before
<<<<<<< HEAD
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given that I imported classes for the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given that I imported members for the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"

        Given that the student "William Xavier dos Santos" has left the class "2021.2-CIC0097-TA"
        Given that the class "2021.2 - CIC0097 - TA" was updated with:
            | name            | schedule |
            | BANCOS DE DADOS | 24T45    |
        And I am on the "Importar dados" page
=======
>>>>>>> 4d70a3f (update)

    Scenario: Coordinator attempts to update class data

        Given I am an authenticated Coordinator
        And I am on the "Importar dados" page
        When I click on "Tipos de dados"
        And I choose "Turmas"
<<<<<<< HEAD
        When I press "Upload"
        And I import a "json" file with the updated classes data
        When I press "Importar"
        Then I should see "Dados das turmas importados com sucesso"
        When I go to the "Turmas" page
        Then I should see "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        And I should see the following classes:
            | name                    | semester | subject | classCode | schedule |
            | BANCOS DE DADOS         | 2021.2   | CIC0097 | TA        | 24T45    |
            | ENGENHARIA DE SOFTWARE  | 2021.2   | CIC0105 | TA        | 35M12    |
            | PROGRAMAÇÃO CONCORRENTE | 2021.2   | CIC0202 | TA        | 35M34    |

    Scenario: Coordinator attempts to update class members data
        And I choose "Membros"
        And I press "Upload"
        And I import a "json" file with the members data
        When I press "Importar"
        Then I should see "Dados dos alunos importados com sucesso"
        When I go to the "Turmas" page
        Then I should see "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        And I should see the following classes:
            | name                    | semester | subject | classCode | schedule |
            | BANCOS DE DADOS         | 2021.2   | CIC0097 | TA        | 35T45    |
            | ENGENHARIA DE SOFTWARE  | 2021.2   | CIC0105 | TA        | 35M12    |
            | PROGRAMAÇÃO CONCORRENTE | 2021.2   | CIC0202 | TA        | 35M34    |
        When I follow "2021.2_CIC0197_TA"
        Then I should be on the "2021.2/CIC0197/TA" page
        And I should see "MARISTELA TERTO DE HOLANDA"
        And I should not see "William Xavier dos Santos"
=======
        And I click "Upload"
        And I choose a json file
        And I click "Importar"
        And I click on "Sobrescrever dados existentes"
        Then I should be able to update the old data

    Scenario: Coordinator attempts to update members data
        Given Im an authenticated Coordinator
        And I am on the "Importar dados" page
        When I click on "Tipos de dados"
        And I choose "Membros"
        And I click "Upload"
        And I choose a json file
        And I click "Importar"
        And I click on "Sobrescrever dados existentes"
        Then I should be able to replace the old data about members
>>>>>>> 4d70a3f (update)
