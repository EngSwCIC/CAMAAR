Feature: Create targeted evaluation form from template
  As an Administrator
  I want to create an evaluation form based on a template
  For selected classes and for either students or instructors
  So that I can assess class performance in the current semester

  Background:
    Given I am logged in as an administrator
    And a template named "Avaliação de matéria" exists
    And a template named "Avaliação semestral" exists
    And a class named "Engenharia de Software" with code "CIC0105" exists

  Scenario: Create evaluation form for students of selected classes
    When I choose the template "Avaliação de matéria"
    And I select the class "Engenharia de Software"
    And I set the evaluation target to "alunos"
    And I set the semester to "2025.1"
    And I confirm the creation
    Then the system should create evaluation forms for the selected classes
    And the forms should be intended to be answered by students

  Scenario: Create evaluation form for instructors of selected classes
    When I choose the template "Avaliação semestral"
    And I select the class "Engenharia de Software"
      # Talvez desnecessário para professores
    And I set the evaluation target to "professores"
    And I set the semester to "2025.1"
    And I confirm the creation
    Then the system should create an evaluation form for "Engenharia de Software"
    And the form should be intended to be answered by professors

  Scenario: Attempt to create form without selecting classes
    When I choose the template "Avaliação de matéria"
    And I do not select any class
    And I set the evaluation target to "alunos"
    And I confirm the creation
    Then the system should show the error message "Matéria não selecionada"
