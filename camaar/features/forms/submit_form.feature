Feature: Submit form answers
    As an Student or Teacher
    I want to answer the form about the class I am associated with
    So that I can submit my class evaluation

    Background: A form was assigned to some classes
        Given that a form has been assigned to the following classes:
            | CIC0097 | 2021.2 | TA |
            | CIC0105 | 2021.2 | TA |
        Given that I am an User associated with the following classes:
            | CIC0097 | 2021.2 | TA |

    Scenario: User tries to submit a form
        Given I am an authenticated User
        When I follow "Formulários"
        Then I should be on the "Formulários" page
        Then I expect to see the following forms as pending:
            | CIC0097 | 2021.2 | TA |
        When I follow "Formulário 1"
        Then I should be on the "Formulário 1" page

        Then I expect to see the following:
            | Formulário 1 |
            | Questão 1    |
            | Questão 2    |
        And I fill in "Questão 1" with "Resposta"
        And I select "option 1" from "Questão 2"
        When I press "Enviar"
        And I confirm a popup
        Then I should be on the "Formulários" page
        And I expect to see the following forms as answered:
            | CIC0097 | 2021.2 | TA |

    Scenario: User can't submit a form
        Given I am an authenticated User
        When I follow "Formulários"
        Then I should be on the "Formulários" page
        Then I should no forms as pending
        And I should not be able to submit a form

    Scenario: Student views forms questions
        Given I am enrolled in a class "<TP1>"
        When I click on the associated form with ID "<TP1>"
        Then I should be on the page for form "<TP1>"
        And I expect to see all the questions to be answered.

        Examples:
            | TP1     |
            | CIC0197 |

