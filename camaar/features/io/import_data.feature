Feature: Registers students data on the system

    As a Coordinator
    I want to register participants data into the system
    So that they can create accounts on the CAMAAR system

    Background: No data has been imported before
        <<<<<<< HEAD
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        And I am on the "Importar dados" page
        When I press "Tipos de dados"


    Scenario: Coordinator imports classes data
        And I choose "Turmas"
        When I press "Upload"
        And I import a "json" file with the classes data
        When I press "Importar"
        Then I expect to see "Dados das turmas importados com sucesso"
        When I go to the "Turmas" page
        And I expect to see the following classes:
            | name                    | semester | subject | classCode | schedule |
            | BANCOS DE DADOS         | 2021.2   | CIC0097 | TA        | 35T45    |
            | ENGENHARIA DE SOFTWARE  | 2021.2   | CIC0105 | TA        | 35M12    |
            | PROGRAMAÇÃO CONCORRENTE | 2021.2   | CIC0202 | TA        | 35M34    |

    Scenario: Coordinator imports members data
        And I choose "Membros"
        And I press "Upload"
        And I import a "json" file with the members data
        When I press "Importar"

        Given that I imported classes for the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Then I expect to see "Dados dos alunos importados com sucesso"
        When I go to the "Turmas" page
        And I expect to see the following classes:
            | name                    | semester | subject | classCode | schedule |
            | BANCOS DE DADOS         | 2021.2   | CIC0097 | TA        | 35T45    |
            | ENGENHARIA DE SOFTWARE  | 2021.2   | CIC0105 | TA        | 35M12    |
            | PROGRAMAÇÃO CONCORRENTE | 2021.2   | CIC0202 | TA        | 35M34    |
        When I follow "BANCOS DE DADOS"
        Then I should be on the "2021.2/CIC0197/TA" page
        And I expect to see "MARISTELA TERTO DE HOLANDA"
        And I expect to see "William Xavier dos Santos"

    Scenario: Coordinator mismatches the file
        And I choose "Turmas"
        When I press "Upload"
        And I import a "txt" file
        When I press "Importar"
        Then I expect to see "Formato Inválido"

