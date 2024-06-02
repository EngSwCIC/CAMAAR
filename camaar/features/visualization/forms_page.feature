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
        Then I should see the following forms as pending:
            | CIC0097 | 2021.2 | TA |
            | CIC0105 | 2021.2 | TA |

    Scenario: Student views answered forms
        Given that I have answered the following forms:
            | CIC0097 | 2021.2 | TA |
        Then I should see the following forms as pending:
            | CIC0097 | 2021.2 | TA |
        Then I should see the following forms as answered:
            | CIC0097 | 2021.2 | TA |


    Scenario: User not associated with any class
        Given I am not enrolled in any class
        Then I should not see any forms on the "Formulários" page

#submit_form.feature
# Scenario: Student views forms questions
#     Given I am enrolled in a class "<TP1>"
#     When I click on the associated form with ID "<TP1>"
#     Then I should be on the page for form "<TP1>"
#     And I should see all the questions to be answered.

#     Examples:
#         | TP1     |
#         | CIC0197 |

#auth scenario
# Scenario: Student Logs Out
#     Given I am on "User Camaar" page
#     And I click on "Sair"
#     Then I should be redirected to the "Root" page.

#submit_form.feature
# Scenario: Student Searches For A Form By Class Code
#     Given I enter <TP1> class code into the search bar
#     And I click on the "Pesquisar" button
#     Then I should see a list of forms that match the input.
#     Examples:
#         | TP1     |
#         | CIC0197 |

# Scenario: Student tries to answer forms
#     Given I am on the "Formulários" page
#     And I follow "Avaliação Institucional"
#     When I check '5' in 'Avalie CIC0197'
#     And I check '5' in 'Avalie CIC0099'
#     And I check 'Marcus Vinicius Lamar' in 'Selecione seus melhores professores'
#     And I fill in 'Alguma reclamação adicional?' with 'None'
#     Then I should be on the "User Camaar"
#     And I should see 'Avaliação Institucional' as answered.