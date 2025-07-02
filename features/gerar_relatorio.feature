Feature: View and export form responses

  As an Administrator
  I want to view the evaluation forms created
  So that I can generate reports based on the responses

  Background:
    Given I am logged in as an administrator
    And And a template named "Avaliação de matéria" and with semester "2025.1" exists
    And a template named "Avaliação semestral" and with semester "2025.1" exists
    And a class named "Engenharia de Software" with code "CIC0105" exists

  Scenario: Export form responses as CSV
    Given the form "Avaliação semestral" "2025.1" has responses
    When I download the CSV report for the form "Avaliação semestral" "2025.1"
    Then a CSV file containing the responses should be generated

  Scenario: Attempt to export CSV for form with no responses
    Given the form "Avaliação de matéria" "2025.1" has no responses
    When I try to download the CSV report for the form "Avaliação de matéria" "2025.1"
    Then I should see the message "Relatório não disponível"
