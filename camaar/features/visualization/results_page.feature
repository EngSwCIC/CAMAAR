Feature: Forms Results Page

    As an administrator
    I want to view the created forms
    So that I can generate a report from the responses.

    Background:
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given that I dispatched a form to the following classes:
            | name           | role    | subject | semester | classCode |
            | "Formulário 1" | student | CIC0097  | 2021.2   | TA        |
            | "Formulário 2" | student | CIC0105  | 2021.2   | TA        |
        Given that the "Formulário 1" have been answered
        And I am on the "Resultados" page

    Scenario: Coordinator views dispatched forms
        Then I should see the following:
            | name         | status   |
            | Formulário 1 | answered |
            | Formulário 2 | pending  |
        And should be able to see all the dispatched forms

    Scenario: Export the responses of a answered form
        When I press the "Exportar Respostas" button from "Formulário 1"
        Then I should download a "csv" file with all the answers

    Scenario: Generate a report from the responses of a answered form
        When I click on the "Converter para gráfico" button
        Then I should be able to see the answered form as a chart.

# auth feature
# Scenario: Coordinator Logs Out
#     Given I am on "Admin Camaar" page
#     And I click on "Sair"
#     Then I  should be redirected to the "Root" page.
