Feature: View pending forms
    As a Student 
    I want to visualize forms not answered yet from classes I am enrolled in
    So that I can choose which one I will fill in

    Scenario: A form has been sent to the class (happy path)
        Given I am logged in as a Student
        And I am on the Avaliacoes page
        And a form has been sent to the class "Turma1"
        Then I should see form "Teste1"

    Scenario: No form has been sent to the class (sad path)
        Given I am logged in as a Student
        And I am on the Avaliacoes page
        And no form has been sent to the class "Turma1"
        Then I should see "Nenhum formulario disponível para a turma "Turma1""
