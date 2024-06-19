Feature: Submit form answers
    As an Student or Teacher
    I want to answer the form about the class I am associated with
    So that I can submit my class evaluation

    Background: A form was assigned to some classes
        Given that a form has been assigned to the students of the following classes:
            | subject | semester | code |
            | CIC0097 | 2021.2   | TA   |
        Given I am an authenticated Student associated with the following classes:
            | subject | semester | code |
            | CIC0097 | 2021.2   | TA   |

    Scenario: User tries to submit a form

        Then I expect to be on the "Forms" page
        When I follow "Pendentes"

        Then I expect to see "Formulário Aluno"
        When I follow "Formulário Aluno"
        Then I expect to be on the "Formulário Aluno" page

        And I expect to see the following:
            | name                       |
            | Formulário Aluno           |
            | Classifique seu rendimento |
            | Dê uma sugestão            |

        And I choose "Question 1 Option 1"
        And I fill in "Question 2" with "Resposta"
        When I press "Submit"

        And I follow "Respondidos"
        Then I expect to be on the "Forms" page
        And I expect to see "Formulário Aluno"


    Scenario: User tries to submit a form with no answer
        Then I expect to be on the "Forms" page
        When I follow "Pendentes"

        Then I expect to see "Formulário Aluno"
        When I follow "Formulário Aluno"
        Then I expect to be on the "Formulário Aluno" page
        When I press "Submit"
        Then I expect to be on the "Formulário Aluno" page
        And I expect to see "Responda todas questões."



