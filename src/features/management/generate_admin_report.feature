Feature: Download CSV file containing form results
    As an administrator
    I want to download a CSV file containing the results of a form
    So that I can evaluate the performance of the classes

Background:
    Given I am logged in as an administrator
    And I am on the results page

Scenario: Admin downloads CSV file with form results
    Given there are form results available
    When I select a class
    And I click on "Baixar resultados."
    Then a CSV file containing the form results should be downloaded
    And I should see a confirmation message "Arquivo CSV com os resultados foi baixado com sucesso."

Scenario: Admin tries to download CSV file with no form results available
    Given there are no form results available
    When I select a class
    And I click on "Baixar resultados."
    Then I should see an error message "Ainda não há respostas para o formulário."
    And no CSV file should be downloaded