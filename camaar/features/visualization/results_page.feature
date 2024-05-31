Feature: Forms Results Page

    As an administrator
    I want to view the created forms
    So that I can generate a report from the responses.

    Background:
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
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


# auth feature
# Scenario: Coordinator Logs Out
#     Given I am on "Admin Camaar" page
#     And I click on "Sair"
#     Then I  should be redirected to the "Root" page.
