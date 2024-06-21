Feature: Submit form answers
    As a Teacher
    I want to answer the form about the class I am associated with
    So that I can submit my class evaluation

    Background: A form was assigned to some classes
        Given that a form has been assigned to the teachers of the following classes:
            | subject | semester | code |
            | CIC0097 | 2021.2   | TA   |
        Given I am an authenticated Teacher associated with the following classes:
            | subject | semester | code |
            | CIC0097 | 2021.2   | TA   |

    Scenario: Teacher tries to submit a form

        Then I expect to be on the "Forms" page
        When I follow "Pendentes"

        Then I expect to see "Formulário Professor"
        When I follow "Formulário Professor"
        Then I expect to be on the "Formulário Professor" page

        And I expect to see the following:
            | name                       |
            | Formulário Professor       |
            | Classifique seu rendimento |
            | Dê uma sugestão            |

        And I choose "Question 1 Option 1"
        And I fill in "Question 2" with "Resposta"
        When I press "Submit"

        And I follow "Respondidos"
        Then I expect to be on the "Forms" page
        And I expect to see "Formulário Professor"


    Scenario: User tries to submit a form with no answer
        Then I expect to be on the "Forms" page
        When I follow "Pendentes"

        Then I expect to see "Formulário Professor"
        When I follow "Formulário Professor"
        Then I expect to be on the "Formulário Professor" page
        When I press "Submit"
        Then I expect to be on the "Formulário Professor" page
        And I expect to see "Responda todas questões."



