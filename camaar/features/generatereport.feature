# Eu como Administrador
# Quero baixar um arquivo csv contendo os resultados de um formulário
# A fim de avaliar o desempenho das turmas

Feature: Download for results

    Background:
        Given I'm an Admin
        And I see the Form results

    Scenario: Download results
        When I click on the download results Button
        Then I should initiate a download of the CSV file

    Scenario: No results
        When I click on the download results Button
        And there are no results
        Then I should be prompted with "Não há resultados para baixar"

    