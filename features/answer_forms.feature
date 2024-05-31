Feature: Respond to Questionnaire
  As a student enrolled in a class
  I want to respond to the questionnaire about the class I am enrolled in
  So that I can submit my evaluation of the class

  Background: Starting on the questionnaire page
    Given I am on the Avaliacoes page

  Scenario: Successfully submitting the questionnaire (happy path)
    When I fill in "O que você achou da turma?" with "Ótima turma"
    And I fill in "O que você achou do professor?" with "Ótimo professor"
    And I press "Enviar"
    Then I should see "Obrigado pelas respostas"
    And my responses should be saved in the database

  Scenario: Submitting an incomplete questionnaire (sad path)
    When I press "Enviar"
    Then I should see "Por favor, responda todas as perguntas obrigatórias"
    And I should be on the Form page
    And my responses should not be saved in the database
