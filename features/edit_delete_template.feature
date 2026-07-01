Feature: Edit and/or delete template

  Eu como Administrador
  Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

  Background:
    Given I am authenticated as an "Administrador"

  # criar
  Scenario: Edit a template title successfully(happy path)
    
    # setup inicial
    Given I have the following templates saved:
      | titulo                                |
      | Template Prova Matemática 2º semestre |
    And the template "Template Prova Matemática 2º semestre" has the following elementos:
      | enunciado_elemento           | tipo_campo       | enunciado_campo |
      | Questão 1(2 pontos):         | multipla_escolha | a: b: c: d:     |
      | Questão 2(2 pontos):         | multipla_escolha | a: b: c: d:     |
      | Questão 3(3 pontos):         | multipla_escolha | a: b: c: d:     |   
      | Questão 4(3 pontos):         | multipla_escolha | a: b: c: d:     | 
      | Questão desafio(1 ponto):    | multipla_escolha | a: b: c: d:     |
    When I go to the "Meus Templates" page
    And I follow "Editar" for "Template Prova Matemática 2º semestre"

    And I change the "titulo" to "Template Matemática Atualizado"
    And I change the elemento "Questão desafio(1 ponto): " to ""
    And I press "Salvar"
    Then I should see a success message "Template atualizado com sucesso!"
    And I should see "Template Matemática Atualizado"
    But I should not see "Template Prova Matemática 2º semestre"
    And the template "Template Matemática Atualizado" should have the following elementos:
      | enunciado_elemento           | tipo_campo       | enunciado_campo |
      | Questão 1(2 pontos):         | multipla_escolha | a: b: c: d:     |
      | Questão 2(2 pontos):         | multipla_escolha | a: b: c: d:     |
      | Questão 3(3 pontos):         | multipla_escolha | a: b: c: d:     |   
      | Questão 4(3 pontos):         | multipla_escolha | a: b: c: d:     |

  Scenario: Attempt to edit a template with a blank title(sad path)
    Given I have the following templates saved:
      | titulo                                |
      | Template Prova Matemática 2º semestre |
    When I go to the "Meus Templates" page
    And I follow "Editar" for "Template Prova Matemática 2º semestre"
    And I change the "titulo" to ""
    And I press "Salvar"
    Then I should see an error message "Título não pode ficar em branco!"

  # deletar
  Scenario: Delete a template successfully(happy path)
    Given I have the following templates saved:
      | titulo                                |
      | Template Prova Matemática 2º semestre |
    When I go to the "Meus Templates" page
    And I follow "Deletar" for "Template Prova Matemática 2º semestre"
    And I confirm the deletion
    Then I should see a success message "Template deletado com sucesso!"
    And I should not see "Template Prova Matemática 2º semestre"

