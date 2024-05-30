Feature: Forms Results Page

    As an administrator
    I want to view the created forms
    So that I can generate a report from the responses.

    Background: 
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        And I am on the Cammaar home page

    Scenario: Coordinator tries to view submited forms
        Given I follow "Adicionar Formulário"
        Then I should be on the "Formulários" page
        When I check '5' in 'Avalie CIC0197'
        And I check '5' in 'Avalie CIC099'
        And I check 'Marcus Vinicius Lamar' in 'Selecione seus melhores professores'
        And I fill in 'Alguma reclamação adicional?' with 'None'
        Then I should be on the Camaar home page
        And I should see 'newest form'.

    Scenario: Generate a report from the responses
        Given I click 'Charts'
        Then I should bee on Charts page
        When I click 'Generate Report'
        Then I should see the downloaded report.
    
    Scenario: Coordinator Views Answered Forms
        Given I follow "Resultados"
        Then I should be on the "results" page
        And should be able to see all the answered forms
    
    Example:
        Given the following forms have been answered:
        . | Template 1            |
          | CIC0097 - 2021.2 - TA |
          | <class_teacher>       |

        . | Template 1            |
          | CIC0105 - 2021.2 - TA |
          | <class_teacher>       |
        
        Then I should see the following resources:
        | Template 1             (Converter para gráfico) | | Template 1             (Converter para gráfico) | 
        | CIC0097 - 2021.2 - TA                           | | CIC0105 - 2021.2 - TA                           |
        | <class_teacher>                        (Baixar) | | <class_teacher>                        (Baixar) |

    Scenario: Coordinator Views Answered Forms As Charts
        Given I follow "Resultados"
        Then I should be on the "results" page
        Given I click on the "Converter para gráfico" button
        Then I should be able to see the answered form as a chart.

    Scenario: Coordinator Logs Out
        Given I log out by clicking on the "Sair" button
        Then I should no longer see any templates
        And should be redirected to the login page.
