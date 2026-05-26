Feature: Answer evaluation form
  As a student of the CAMAAR system
  I want to fill in and submit the answers of an evaluation form
  So that I can complete my evaluation of the subject

  Background:
    Given I am logged in as a student user
    And I have already accessed the form page for the subject "Engenharia de Software"

  Scenario: [Happy Path] Submit form with all answers filled in
    When I fill the multiple choice question with "Excelente"
    And I fill the open-ended question with "O conteúdo foi muito bem ministrado."
    And I click the "Submit Evaluation" button
    Then the system should record my answers
    And I should be redirected to the class list
    And I should see the green message "Avaliação enviada com sucesso!"

  Scenario: [Sad Path] Attempt to submit with required questions left blank
    When I do not select any option in the multiple choice question
    And I leave the open-ended question blank
    And I click the "Submit Evaluation" button
    Then the system should not process the submission
    And I should see the alert "Existem questões obrigatórias não respondidas."
