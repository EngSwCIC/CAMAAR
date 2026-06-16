Feature: Download results as CSV
  As an Administrator
  I want to download a CSV file containing the results of a form
  So that I can evaluate the performance of the classes

  Background:
    Given I am logged in as the "Administrador" profile
    And I navigate to the forms page

  Scenario: [Happy Path] Download CSV of an answered form
    Given an answered form named "Avaliação ES 2026.1" exists
    And I click on the form named "Avaliação ES 2026.1"
    When I follow "Baixar Relatório (CSV)"
    Then the browser should start downloading the file "avaliacao_es_2026_1.csv"
    And the CSV file should contain the header with the form questions
    And the CSV file should contain one row per submitted answer

  Scenario: [Sad Path] Form with no answers does not allow download
    Given a form with no answers named "Avaliação BD 2026.1" exists
    And I click on the form named "Avaliação BD 2026.1"
    When I follow "Baixar Relatório (CSV)"
    Then I should see the message "Não há respostas para exportar"
    And no CSV file should be downloaded
