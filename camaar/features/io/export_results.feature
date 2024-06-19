Feature: Export form results

    As a Coordinator
    I want to download a CSV file containing the results of a form
    So that I can evaluate the performance of the classes

    Background: Form has already been answered
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given that a form has been assigned to students of the following classes:
            | subject | semester | classCode |
            | CIC0097 | 2021.2   | TA        |
            | CIC0105 | 2021.2   | TA        |
        And I am on the "Resultados" page
        Given that the "Formulário Aluno" form has been answered


    Scenario: Export the responses of a answered form
        When I press "Exportar Respostas"
        Then I should download be able to export a "csv" file with all the answers

    Scenario: Generate a report from the responses of a answered form
        When I press "Converter para gráfico"
        Then I should be able to see the answered form as a chart

        Scenarios: Export the responses of a deleted form
        Given I am at "Formulários page"
        And I delete "<Formulário 1>"
        Then I should not see "<Formulário 1>"
        When I visit "Resultados" page
        Then I should not be able to export the responses from "<Formulário 1>"
