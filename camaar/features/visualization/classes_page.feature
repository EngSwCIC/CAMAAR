Feature: View department classes

    As a Coordinator
    I want to view the department classes
    So that I know which subject classes exists for the current semester


    Background:
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given that I imported classes for the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given I am on the "Turmas" page

    Scenario:
        Then I should see "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Then I should see the following classes:
            | name                    | subject | classCode | semester | schedule |
            | BANCOS DE DADOS         | CIC0097 | TA        | 2021.2   | 35T45    |
            | ENGENHARIA DE SOFTWARE  | CIC0105 | TA        | 2021.2   | 35M12    |
            | PROGRAMAÇÃO CONCORRENTE | CIC0202 | TA        | 2021.2   | 35M34    |

