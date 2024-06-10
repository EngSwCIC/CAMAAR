Feature: View forms as a Student or Teacher

    As a Student or Teacher
    I want to view the unanswered forms for the classes I am associated with
    So that I can choose which one to respond to

    Background: A form was assigned to some classes
        Given I am an authenticated User
        Given that a form has been assigned to the following classes:
            | Formulário 1 | teacher | CIC0097 | 2021.2 | TA |
            | Formulário 2 | student | CIC0105 | 2021.2 | TA |
        Given that I am an User associated with the following classes:
            | CIC0097 | 2021.2 | TA |
            | CIC0105 | 2021.2 | TA |
        When I follow "Formulários"
        Then I should be on the "Formulários" page

    Scenario: Student views pending forms
        Given that I have not answered any form
        Then I expect to see the following forms as pending:
            | CIC0097 | 2021.2 | TA |
            | CIC0105 | 2021.2 | TA |

    Scenario: Student views answered forms
        Given that I have answered the following forms:
            | CIC0097 | 2021.2 | TA |
        Then I expect to see the following forms as pending:
            | CIC0097 | 2021.2 | TA |
        Then I expect to see the following forms as answered:
            | CIC0097 | 2021.2 | TA |


    Scenario: User not associated with any class
        Given I am not enrolled in any class
        Then I should not see any forms on the "Formulários" page
