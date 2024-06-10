Feature: View department classes

    As a Coordinator
    I want to view the department classes
    So that I know which subject classes exists for the current semester


    Background: Coodinator goes to the department page
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given I am on the "Turmas" page
        Then I expect to see "DEPTO CIÊNCIAS DA COMPUTAÇÃO"

    Scenario: Coordinator from CIC see classes
        Given that I imported classes for the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Then I expect to see the following classes:
            | name                    | subject | classCode | semester | schedule |
            | BANCOS DE DADOS         | CIC0097 | TA        | 2021.2   | 35T45    |
            | ENGENHARIA DE SOFTWARE  | CIC0105 | TA        | 2021.2   | 35M12    |
            | PROGRAMAÇÃO CONCORRENTE | CIC0202 | TA        | 2021.2   | 35M34    |

    Scenario: There are no classes for the department
        Given the department has no classes
        Then I expect to see "O departamento não possui turmas"
        Then I expect to see "Importar turmas"
        When I press "Importar turmas"
        Then I should be on the "Importar dados" page