Feature: Participant viewing unanswered forms

    Background:
        Given I am logged in as a participant user
        And I am enrolled in the class "Engenharia de Software - T01"
        And I am enrolled in the class "Banco de Dados - T02"

    Scenario: View unanswered forms from enrolled classes
        Given there is an unanswered form "Avaliação ES" for the class "Engenharia de Software - T01"
        And there is an unanswered form "Avaliação BD" for the class "Banco de Dados - T02"
        When I navigate to my forms page
        Then I should see a list of unanswered forms
        And the list should include "Avaliação ES"
        And the list should include "Avaliação BD"

    Scenario: Answered forms should not appear in unanswered list
        Given there is an unanswered form "Avaliação ES" for the class "Engenharia de Software - T01"
        And I have already answered the form "Avaliação BD" for the class "Banco de Dados - T02"
        When I navigate to my forms page
        Then the list should include "Avaliação ES"
        And the list should not include "Avaliação BD"

    Scenario: Forms from non-enrolled classes are not visible
        Given there is an unanswered form "Avaliação Externa" for the class "Cálculo I - T03"
        When I navigate to my forms page
        Then the list should not include "Avaliação Externa"

    Scenario: Select a form to answer
        Given there is an unanswered form "Avaliação ES" for the class "Engenharia de Software - T01"
        When I navigate to my forms page
        And I click on the form named "Avaliação ES"
        Then I should see the questions of "Avaliação ES"
