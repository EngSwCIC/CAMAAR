Feature: Export form results

    As a Coordinator
    I want to download a CSV file containing the results of a form
    So that I can evaluate the performance of the classes

    Background: Form has already been answered
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given that I create a form to the following classes:
            | name         | role    | subject | semester | classCode |
            | Formulário 1 | teacher | CIC0097 | 2021.2   | TA        |
            | Formulário 2 | student | CIC0105 | 2021.2   | TA        |
        And I am on the "Resultados" page
        Given that the "Formulário 1" form has been answered


    Scenario: Export the responses of a answered form
        When I press the button "Exportar Respostas"
        Then I should download be able to export a "csv" file with all the answers

    Scenario: Generate a report from the responses of a answered form
        When I prees the button "Converter para gráfico"
        Then I should be able to see the answered form as a chart
