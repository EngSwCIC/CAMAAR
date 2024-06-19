Feature: Update database data

    As a Coordinator
    I want to update the existing database with the current data from SIGAA
    So that I can correct the system's database

    Background: Data has already been imported before
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"


        Given that the student "William Xavier dos Santos" has left the following classes:
            | semester | subject | code |
            | 2021.2   | CIC0097 | TA   |



        And I am on the "Importar dados" page

    Scenario: Coordinator imports updated members data
        When I select "Membros" from "admin_import_select_data"
        When I attach the file "db/updated_class_members.json" to "admin_import_file"
        When I press on "Importar"
        Then I expect to be on the "Importar dados" page
        And I expect to see "Membros importados com sucesso"
        Then I expect the student "William Xavier dos Santos" to not be associated with following classes:
            | semester | subject | code |
            | 2021.2   | CIC0097 | TA   |



    Scenario: Coordinator imports updated classes data
        When I select "Turmas" from "admin_import_select_data"
        When I attach the file "db/updated_classes.json" to "admin_import_file"
        When I press on "Importar"
        Then I expect to be on the "Importar dados" page
        And I expect to see "Turmas importadas com sucesso"

        Then I expect to see "Turmas"
        When I go to the "Meu Departamento" page
        Then I expect to see the following table:
            | Nome | Semestre | Código  | Turma | Horário |
            | BD   | 2021.2   | CIC0097 | TA    | 35M34   |
            | ES   | 2021.2   | CIC0105 | TA    | 35T45   |
            | PC   | 2021.2   | CIC0202 | TA    | 35M12   |