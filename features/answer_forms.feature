Feature: Respond to Questionnaire
  As a student enrolled in a class
  I want to respond to the questionnaire about the class I am enrolled in
  So that I can submit my evaluation of the class

  Background: Starting on the questionnaire page
    Given I am logged in as a student
    And There is a form request

  Scenario: Successfully submitting the questionnaire (happy path)
    When I visit the RespondForm page
    Then I should see "O que você achou da turma?"
    And I should see "O que você achou do professor?"
    When I fill in "answer_0" with "Ótima turma"
    And I fill in "answer_1" with "Ótimo professor"
    And I press "Enviar"
    Then I should see "Obrigado pelas respostas"
    And my responses should be saved in the database

  Scenario: Submitting an incomplete questionnaire (sad path)
    When I visit the RespondForm page
    Then I should see "O que você achou da turma?"
    And I should see "O que você achou do professor?"
    When I press "Enviar"
    Then I should see "Por favor, responda todas as perguntas obrigatórias"
    And I should stay at the RespondForm page
    And my responses should not be saved in the database
