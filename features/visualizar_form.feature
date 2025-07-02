Feature: View pending evaluation forms
  As a Participant enrolled in one or more classes
  I want to view the evaluation forms I have not yet responded to
  So that I can choose which one to answer

  Background:
    Given I am logged in as a participant
    And I am enrolled in the class "Engenharia de Software"
    And the evaluation form "Avaliação de matéria" "2025.1" exist:

  Scenario: View list of pending forms
    Given I have not answered the form "Avaliação de matéria" "2025.1"
    When I access the pending evaluations page
    Then I should see the form "Avaliação de matéria" "2025.1" for the class "Engenharia de Software"

  Scenario: No pending forms
    Given I have answered all evaluation forms for my classes
    When I access the pending evaluations page
    Then I should see the message "Nenhum formulário a ser respondido"
