@report
Feature: Generating CSV report
    @discipline
    Scenario: Downloading discipline CSV report
        Given I am logged in as an administrator
        And I am in the evaluations screen
        And I have a form for discipline "Estrutura de Dados", with professor "DANIEL DE PAULA PORTO" and semester "2020.1"
        When I click Baixar Resultados
        Then I should download a CSV file for that discipline

    @semester
    Scenario: Downloading semester CSV report
        Given I am logged in as an administrator
        And I am in the management screen
        And I have a form for discipline "Estrutura de Dados", with professor "DANIEL DE PAULA PORTO" and semester "2020.1"
        When I click Gerar CSV de Resultados deste Semestre
        Then I should download a CSV file for the disciplines of that semester

    @semester_nil
    Scenario: No semester registered
        Given I am logged in as an administrator
        And I am in the management screen
        And I have no semesters registered
        When I click Gerar CSV de Resultados deste Semestre
        Then I should see "Não é possível exportar resultados sem um semestre cadastrado, importe os dados do sistema."
