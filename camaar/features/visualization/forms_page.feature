Feature: View forms

    As a Student
    I want to view the unanswered forms for the classes I am enrolled in
    So that I can choose which one to respond to.

    Background: 
        Given forms have been assigned to classes 
        And I am an authenticated Student
        When I follow "Formulários"
        Then I should be on the "forms" page.

    Scenario: Student Views Forms (No Forms Answered)
        Given I am enrolled in any class
        And I havent answered any forms
        Then all the forms should be marked as pending
        And I should see the forms of all classes I am enrolled in
    
    Example: 
        Given I am enrolled in the classes:
        . BANCOS DE DADOS
        . ENGENHARIA DE SOFTWARE

        Then I should see the following forms:
        | Template <template_id> (pending) | | Template <template_id> (pending)| 
        | CIC0097 - 2021.2 - TA            | | CIC0105 - 2021.2 - TA           |
        | <class_teacher>                  | | <class_teacher>                 |
    
    Scenario: Student Views Forms (At Least One Form Answered)
        Given I am enrolled in any class
        And I have already answered at least one form
        Then all the answered forms should be marked as answered
        And I should see the forms of all classes I am enrolled in

    Example: 
        Given I am enrolled in the classes:
        . BANCOS DE DADOS
        . ENGENHARIA DE SOFTWARE

        And I have already answered the BANCO DE DADOS form

        Then I should see the following forms:
        | Template <template_id> (answered) | | Template <template_id> (pending)| 
        | CIC0097 - 2021.2 - TA             | | CIC0105 - 2021.2 - TA           |
        | <class_teacher>                   | | <class_teacher>                 |
    

    Scenario: Student views forms questions
        Given I am assigned to a class "<id_class>"
        When I click on the associated form with ID "<id_form>"
        Then I should be on the page for form "<id_form>"
        And I should see all the questions to be answered.

    Scenario: Student Logs Out
        Given I log out by clicking on the "Sair" button
        Then I should no longer see any forms
        And should be redirected to the login page.

    Scenario: Student Searches for a Form By Class Code
        Given I enter a class code into the search bar
        And I click on the "Pesquisar" button
        Then I should see a list of forms that match the input.