Feature: View pending forms
    As a Student 
    I want to visualize forms not answered yet from classes I am enrolled in
    So that I can choose which one I will fill in

    Scenario: A form has been sent to the class (happy path)
        Given I am logged in as a student from class "Turma1"
        And a form has been sent to this user
        And I am on the Avaliacoes page
        Then I should see form "Turma1"

    Scenario: No form has been sent to the class (sad path)
        Given I am logged in as a student from class "Turma1"
        And I am on the Avaliacoes page
        And There are no forms registered
        Then I should see no form "Turma1"
