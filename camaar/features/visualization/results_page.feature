Feature: Forms Results Page

    As a Coodinator
    I want to view the created forms
    So that I can generate a report from the responses.

    Background:
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given that I imported classes for the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"

        Given that a form has been assigned to the following classes:
            | name         | role    | subject | semester | classCode |
            | Formulário 1 | teacher | CIC0097 | 2021.2   | TA        |
            | Formulário 2 | student | CIC0105 | 2021.2   | TA        |
        And I am on the "Resultados" page

    Scenario: Coordinator views dispatched forms
        Given that the "Formulário 1" form has been answered
        Then I should see the following results:
            | name         | answers      |
            | Formulário 1 | Respostas: 1 |
            | Formulário 2 | Respostas: 0 |

    Scenario: Coordinator only sees the answered forms
        Given that the "Formulário 1" form has been answered
        Then I should see the following results:
            | name         | answers      |
            | Formulário 1 | Respostas: 1 |

    Scenario: Coordinator only sees the created forms
        Given that I expect to see forms
        And I am on "Formulários Page"
        But there are no forms created
        Then I should not see any forms
