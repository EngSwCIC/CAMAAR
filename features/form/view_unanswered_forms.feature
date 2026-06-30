Feature: Participant viewing unanswered forms

    Background:
        Given I am logged in as a participant user
        And I am enrolled in the class "Engenharia de Software - T01"
        And I am enrolled in the class "Banco de Dados - T02"

    Scenario: View unanswered forms from enrolled classes
        Given There is an evaluation form named "Avaliação de Disciplina - Engenharia de Software" for the class "Engenharia de Software", with code "CIC0105", class code "TA", semester "2021.2"
        And There is an evaluation form named "Avaliação de Disciplina - Banco de Dados" for the class "Banco de Dados", with code "CIC0105", class code "BD", semester "2021.2"
        When I navigate to the forms page
        Then I should see a list of unanswered forms

    Scenario: Answered forms should not appear in unanswered list
        Given I have already answered the form "Avaliação de Disciplina - Banco de Dados" for the class "Banco de Dados"
        When I navigate to the forms page
        Then the list should not include "Avaliação de Disciplina - Banco de Dados" within "Pendentes"

    Scenario: Forms from non-enrolled classes are not visible
        Given There is an evaluation form named "Avaliação Externa" for the class "Cálculo I", with code "MAT101", class code "TC", semester "2021.2"
        When I navigate to the forms page
        Then the list should not include "Avaliação Externa" within "Pendentes"

    Scenario: Select a form to answer
        Given There is an evaluation form named "Avaliação de Disciplina - Engenharia de Software" for the class "Engenharia de Software", with code "CIC0105", class code "TA", semester "2021.2"
        When I navigate to the forms page
        And I access the "Avaliação de Disciplina - Engenharia de Software" forms page
        Then I should see the questions of "Avaliação de Disciplina - Engenharia de Software"
