Feature: View Template

    Eu como Administrador
    Quero visualizar os templates criados
    A fim de poder editar e/ou deletar um template que eu criei 

  Background:
    Given I am authenticated as an "Administrador"

  Scenario: View template list successfully(happy path)
    Given I have the following templates saved:
      | titulo                                |
      | Template Prova Matemática 2º semestre |
      | Template Prova Português 2º semestre  |
    When I go to the "Meus Templates" page
    Then I should see "Template Prova Matemática 2º semestre"
    And I should see "Template Prova Português 2º semestre"
    And I should see options to "Editar" and "Deletar" for each template

  Scenario: View empty template list(sad path)
    Given I have no templates saved
    When I go to the "Meus Templates" page
    Then I should see the message "Nenhum template encontrado."
    And I should see a button "Criar novo template"