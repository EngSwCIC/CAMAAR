Feature: Viewing created forms

    Background:
        Given I am logged in as an admin user
        And I am on the dashboard page

    Scenario: View list of created forms
        Given I have created a form called "Avaliação Docente 2026.1"
        And I have created a form called "Avaliação Discente 2026.1"
        When I navigate to the forms page
        Then I should see a list of created forms
        And the list should include "Avaliação Docente 2026.1"
        And the list should include "Avaliação Discente 2026.1"

    Scenario: View form details to generate a report
        Given I have created a form called "Avaliação Docente 2026.1"
        When I navigate to the forms page
        And I click on the form named "Avaliação Docente 2026.1"
        Then I should see the responses of "Avaliação Docente 2026.1"
        And I should see an option to "Baixar relatório (CSV)"

    Scenario: View empty forms list
        When I navigate to the forms page
        Then I should see the message "Nenhum formulário criado"
