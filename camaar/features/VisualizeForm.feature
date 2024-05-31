#Eu como Participante de uma turma
#Quero visualizar os formulários não respondidos das turmas em que estou matriculado
#A fim de poder escolher qual irei responder

Feature: visualize forms

    Scenario: pending forms
        Given I am a registered user
        And I am registered on a class with active forms
        And I have unanswered forms
        Then I should see them on the homepage

    Scenario: pending form expired
        Given I am a registered user
        And I am registered on a class with active forms
        When an active form expires
        Then I should not see it on the homepage

    Scenario: pending form deleted
        Given I am a registered user
        And a teacher closed the form before it's expiration date
        Then I should not see it on the homepage

#Estamos considerando que a homepage é apenas para formulários pendentes nesse cenário
    Scenario: answered forms
        Given I am a registered user
        And I am registered on a class with active forms
        And I answered a form
        Then I should not see it on the homepage

#Para o caso em que a homepage também deve exibir formulários já respondidos
    Scenario: answered forms
        Given I am a registered user
        And I am registered on a class with active forms
        And I answered a form
        Then I should still see it on the homepage

        
