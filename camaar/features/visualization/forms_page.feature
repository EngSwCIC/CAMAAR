Feature: View forms as a Student or Teacher

    As a Student or Teacher
    I want to view the unanswered forms for the classes I am associated with
    So that I can choose which one to respond to

    Background: Student belongs to "BANCOS DE DADOS"
        Given that a form has been assigned to the students of the following classes:
            | subject | semester | code |
            | CIC0097 | 2021.2   | TA   |

        Given I am an authenticated Student associated with the following classes:
            | subject | semester | code |
            | CIC0097 | 2021.2   | TA   |



    Scenario: Student views pending forms
        When I follow "Pendentes"
        Then I expect to be on the "Forms" page
        Then I expect to see "Formulário Aluno"

    Scenario: Student views answered forms
        Given that I answered the "Formulário Aluno" form

        When I follow "Respondidos"
        Then I expect to be on the "Forms" page
        And I expect to see "Formulário Aluno"

        When I follow "Formulário Aluno"
        Then I expect to be on the "Respostas Formulário Aluno" page
        And I expect "Question 1 Option 1" to be checked
        And I expect to see "Resposta"

    Scenario: User not associated with any class
        Given I am not enrolled in any class
        When I follow "Pendentes"
        Then I expect to be on the "Forms" page
        Then I expect to not see "Formulário Aluno"