Feature: View department classes

    As a Coordinator
    I want to view the department classes
    So that I know which subject classes exists for the current semester


    Background: Coodinator goes to the department page
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given I am on the "Meu Departamento" page
        Then I expect to see "DEPTO CIÊNCIAS DA COMPUTAÇÃO"

    Scenario: Coordinator from CIC see classes
        Given that I imported classes for the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Then I expect to see the following:
            | BANCOS DE DADOS         |
            | ENGENHARIA DE SOFTWARE  |
            | PROGRAMAÇÃO CONCORRENTE |

    Scenario: There are no classes for the department
        Given the "DEPTO CIÊNCIAS DA COMPUTAÇÃO" department has no classes
        Then I expect to see "O departamento não possui turmas"
        Then I expect to see "Importar turmas"
        When I press "Importar turmas"
        Then I should be on the "Importar dados" page