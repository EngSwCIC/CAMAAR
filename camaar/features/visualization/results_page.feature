Feature: Forms results page

    As an administrator
    I want to view the created forms
    So that I can generate a report from the responses

    Scenario: Coordinator tries to ciew submited forms
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        And I am on the Camaar home page
        When I follow "Adicionar Formulário"
        Then I should be on the "Formulários" page
        When I check '5' in 'Avalie CIC0197'
        And I check '5' in 'Avalie CIC099'
        And I check 'Marcus Vinicius Lamar' in 'Selecione seus melhores professores'
        And I fill in 'Alguma reclamação adicional?' with 'None'
        Then I should be on the Camaar home page
        And I should see 'newest form'

    Scenario: Generate a report from the responses
        Given I am logged in
        And I am on the Camaar home page
        When I click 'Charts'
        Then I should bee on Charts page
        When I click 'Generate Report'
        Then I should see the downloaded report
