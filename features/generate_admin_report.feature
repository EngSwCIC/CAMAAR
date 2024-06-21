Feature: Generate Admin Report
    As an administrator
    I want to download a csv file containing the results of a form
    So that I can evaluate class performance

  Scenario: Click on class report to download result (happy path)
    Given there is one form answered for "Turma"
    And I am on the Resultados page
    Then I should see "Turma"
    When I follow "Turma"
    Then I should see "turma,semestre,pergunta,resposta,data"
    When I go to the Resultados page
    Then I should see "Relatório baixado com sucesso."

  Scenario: No results (sad path)
    Given there is no form answered for "Turma"
    And I am on the Resultados page
    And I should see "Turma"
    When I follow "Turma"
    Then I should see "Nenhum formulário respondido."
