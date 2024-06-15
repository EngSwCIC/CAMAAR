Feature: Registers students data on the system

    As a Coordinator
    I want to register participants data into the system
    So that they can create accounts on the CAMAAR system

    Background: No data has been imported before
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        And I am on the "Importar dados" page

    # Scenario: Coordinator imports departments data
    #     When I select "Departamentos" from "admin_import_select_data"
    #     When I attach the file "db/departments.json" to "admin_import_file"
    #     When I press on "Importar"
    #     Then I expect to be on the "Importar dados" page


    Scenario: Coordinator imports members data
        When I select "Membros" from "admin_import_select_data"
        When I attach the file "db/class_members.json" to "admin_import_file"
        When I press on "Importar"
        Then I expect to be on the "Importar dados" page

    Scenario: Coordinator imports classes data
        When I select "Turmas" from "admin_import_select_data"
        When I attach the file "db/classes.json" to "admin_import_file"
        When I press on "Importar"
        Then I expect to be on the "Importar dados" page

        Then I expect to see "Turmas"
        When I go to the "Meu Departamento" page
        Then I should see the following on Turmas:
        | Nome                    | Semestre | Código  | Turma     | Horário  |
        | BANCOS DE DADOS         | 2021.2   | CIC0097 | TA        | 35T45    |
        | ENGENHARIA DE SOFTWARE  | 2021.2   | CIC0105 | TA        | 35M12    |
        | PROGRAMAÇÃO CONCORRENTE | 2021.2   | CIC0202 | TA        | 35M34    |

    Scenario: Coordinator is not Root admin
        When I select "Departamentos" from "admin_import_select_data"
        When I attach the file "db/departments.json" to "admin_import_file"
        When I press on "Importar"
        Then I expect to see "Você não é admin ROOT"

