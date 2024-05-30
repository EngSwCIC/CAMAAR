Feature: Create form template
  As an Administrator
  I want to create a form template containing the form questions
  So that I can generate evaluation forms to evaluate classes' performances

  # tem que ver os labels dos botoes tbm
  Background: Starting on the gerenciamento page
    Given I am on the Templates page
    When I press "+"
    Then I should see "Nome do template"

  Scenario: Not filling a field (sad path)
    When I press "Criar"
    Then I should be on the Templater page
    And I should see "Erro: campos nao preenchidos"

  # assumindo que a criacao de template aparece com nenhuma questao padrao
  Scenario: Filling all correctly (happy path)
    When I fill in "Nome do template:" with "Temp Teste"
    And I create a question of type "Radio"
    Then I should see "Questão 1"
    When I create a question of type "Texto"
    Then I should see "Questão 2"
    When I press "Criar"
    Then I should be on the Templates page
    And I should see "Temp Teste"