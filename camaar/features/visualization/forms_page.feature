Feature: View forms

    As a Student
    I want to view the unanswered forms for the classes I am enrolled in
    So that I can choose which one to respond to

    Background: 
        Given that forms have been assigned to classes 
        And I am an authenticated Student
        When I follow "Formulários"
        Then I should be on the "forms" page

    Scenario: Student views forms (no forms answered)
        Given I am assigned to any class
        And I havent answered any forms
        Then I should see the forms of all classes I am enrolled in
    
    Example: 
        Student assigned to class: BANCOS DE DADOS and ENGENHARIA DE SOFTWARE

        Should see:
        | Template <template_id> | | Template <template_id> | 
        | CIC0097 - 2021.2 - TA  | | CIC0105 - 2021.2 - TA  |
        | <class_teacher>        | | <class_teacher>        |
    
    Scenario: Student views forms (at least one form answered)
        Given I am assigned to any class
        And I have already answered at least one form
        Then I should see the forms of the classes I am enrolled in
        But submited forms are marked as answered
        And I cannot see them in the "forms" page

    Scenario: Student views forms questions
        Given I am assigned to a class "<id_class>"
        When I click on the associated form with ID "<id_form>"
        Then I should be on the page for form "<id_form>"
        And I should see all the questions to be answered