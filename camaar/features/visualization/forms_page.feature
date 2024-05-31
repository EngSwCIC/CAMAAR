Feature: View Forms

    As a Student
    I want to view the unanswered forms for the classes I am enrolled in
    So that I can choose which one to respond to.

    Background: 
        Given forms have been assigned to classes 
        And I am an authenticated Student
        When I follow "Formulários"
        Then I should be on the "forms" page.

    Scenario: Student Views Forms (No Forms Answered)
        Given I am enrolled in <CIC0097> class
        And I havent answered <CIC0097> forms
        Then the  <CIC0097> forms should be marked as pending
        And I should see the pending forms of all classes I am enrolled in
    
        Examples: 
            | CIC0097                | CIC0105     |
            |  CIC0097 - 2021.2 - TA | CIC0105 - 2021.2 - TA |

    Scenario: Student Views Forms (At Least One Form Answered)
        Given I am enrolled in any class
        And I have already answered <CIC0105> form
        Then the <CIC0105> forms should be marked as answered
        And I should see just the pending forms of all classes I am enrolled in.

        Examples: 
            | CIC0097                | CIC0105     |
            |  CIC0097 - 2021.2 - TA | CIC0105 - 2021.2 - TA |

    Scenario: Not Enrolled Student Does Not View Any Forms
        Given I am not enrolled in any class
        Then I should not see any forms on the "forms" page.

    Scenario: Student views forms questions
        Given I am enrolled in a class "<TP1>"
        When I click on the associated form with ID "<TP1>"
        Then I should be on the page for form "<TP1>"
        And I should see all the questions to be answered.

        Examples: 
            | TP1                |
            | CIC0197            |

    Scenario: Student Logs Out
        Given I am on "User Camaar" page
        And I click on "Sair"
        Then I should be redirected to the "Root" page.

    Scenario: Student Searches For A Form By Class Code
        Given I enter <TP1> class code into the search bar
        And I click on the "Pesquisar" button
        Then I should see a list of forms that match the input.
        Examples: 
            | TP1                |
            | CIC0197            |

    Scenario: Student tries to answer forms
        Given I am on the "Formulários" page
        And I follow "Avaliação Institucional"
        When I check '5' in 'Avalie CIC0197'
        And I check '5' in 'Avalie CIC0099'
        And I check 'Marcus Vinicius Lamar' in 'Selecione seus melhores professores'
        And I fill in 'Alguma reclamação adicional?' with 'None'
        Then I should be on the "User Camaar" 
        And I should see 'Avaliação Institucional' as answered.