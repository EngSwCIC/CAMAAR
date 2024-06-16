Feature: View department classes

    As a Coordinator
    I want to view the department classes
    So that I know which subject classes exists for the current semester


    Background: Coodinator goes to the department page
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given I am on the "Meu Departamento" page
        Then I expect to see "DEPTO CIÊNCIAS DA COMPUTAÇÃO"

    Scenario: Coordinator from CIC see classes
        Given that I imported classes for "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        And I am on the "Meu Departamento" page
        Then I should see the following on Turmas:
        | Nome                    | Semestre | Código  | Turma     | Horário  |
        | BANCOS DE DADOS         | 2021.2   | CIC0097 | TA        | 35T45    |
        | ENGENHARIA DE SOFTWARE  | 2021.2   | CIC0105 | TA        | 35M12    |
        | PROGRAMAÇÃO CONCORRENTE | 2021.2   | CIC0202 | TA        | 35M34    |

    Scenario: There are no classes for the department
        Given that the department "DEPTO CIÊNCIAS DA COMPUTAÇÃO" has no classes
        And I am on the "Meu Departamento" page
        Then I expect to see "O departamento não possui turmas"

        Then I expect to see "Importar turmas"
        When I press "Importar turmas"
        Then I expect to be on the "Importar dados" page