Feature: Submit evaluation form

  As a Participant enrolled in a class
  I want to answer the evaluation questionnaire for my class
  So that I can submit my assessment of the class

  Background:
    Given I am logged in as a user
    And I am enrolled in the class "Engenharia de Software"
    And the evaluation form "Avaliação de matéria" "2025.1" is available
    And I have not yet responded to the form

  Scenario: Successfully submit evaluation form
    When I answer the form "Avaliação de matéria" "2025.1"
    And I submit the form
    Then I should see the message "Formulário respondido com sucesso"
    And the form should be marked as completed for me

  Scenario: Attempt to submit without answering all required questions
    When I start answering the form "Avaliação de matéria" "2025.1"
    And I don't provide the answer for a question
    And I submit the form
    Then I should see the error message "Questão não respondida"