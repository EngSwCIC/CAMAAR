Feature: Forms Results Page

    As an administrator
    I want to view the created forms
    So that I can generate a report from the responses.

    Background: 
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        And I am on the Cammaar home page

    Scenario: Generate a report from the responses
        Given I click 'Charts'
        Then I should bee on Charts page
        When I click 'Generate Report' button
        Then I should see the downloaded report.
    
    Scenario: Coordinator Views Answered Forms
        Given I follow "Resultados"
        Then I should be on the "Resultados" page
        And should be able to see all the answered forms

    Scenario: Coordinator Views Answered Forms As Charts
        Given I follow "Resultados"
        Then I should be on the "Resultados" page
        Given I click on the "Converter para gráfico" button
        Then I should be able to see the answered form as a chart.

    Scenario: Coordinator Logs Out
        Given I am on "Admin Camaar" page
        And I click on "Sair"
        Then I  should be redirected to the "Root" page.
