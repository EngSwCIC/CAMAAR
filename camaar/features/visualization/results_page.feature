Feature: Forms Results Page

    As a Coodinator
    I want to view the created forms
    So that I can generate a report from the responses.



    Scenario: Coordinator views dispatched forms answers
        Given that a form assigned to the students of the following classes were answered:
            | subject | semester | code |
            | CIC0097 | 2021.2   | TA   |

        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Resultados"

        Then I expect to see "Formulário Aluno"

        When I follow "Formulário Aluno"
        Then I expect to be on the "Resultados Formulário Aluno" page
        And I expect to see "Formulário Aluno"

        And I expect to see the following:
            | question                       | answer 1 |
            | 1 - Classifique seu rendimento | Ótimo    |
            | 2 - Dê uma sugestão            | Resposta |

        Then I expect to see "Número de respostas: 1/44"


    Scenario: Coordinator tries to see empty form
        Given that a form has been assigned to the teachers of the following classes:
            | subject | semester | code |
            | CIC0097 | 2021.2   | TA   |
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Resultados"

        And I expect to see "Formulário Professor"
        When I follow "Formulário Professor"
        Then I expect to be on the "Resultados Formulário Professor" page

        And I expect to see "Número de respostas: 0/1"

