Feature: Answer evaluation form
  As a student of the CAMAAR system
  I want to fill in and submit the answers of an evaluation form
  So that I can complete my evaluation of the subject

  Background:
    Given I am logged in as a student user
    And There is an evaluation form named "Avaliação de Disciplina - Engenharia de Software" for the class "Engenharia de Software", with code "CIC0105", class code "TA", semester "2021.2"
    And I navigate to the forms page
    And I access the "Avaliação de Disciplina - Engenharia de Software" forms page

  Scenario: [Happy Path] Submit form with all answers filled in
    When I fill the multiple choice question with "Excelente"
    And I fill the open-ended question with "O conteúdo foi muito bem ministrado."
    And I click the "Enviar Respostas" button
    Then the system should record my answers
    And I should be redirected to the forms page
    And I should see the message "Respostas enviadas. Obrigado!"

  Scenario: [Sad Path] Attempt to submit with required questions left blank
    When I fill the multiple choice question with "Excelente"
    And I leave the open-ended question blank
    And I click the "Enviar Respostas" button
    Then I should see the message "Existem questões obrigatórias não respondidas."
