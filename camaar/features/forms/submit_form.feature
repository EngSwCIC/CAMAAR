Feature: Submit form answers

    As a Student
    I want to answer the questionnaire about the class I am enrolled in
    So that I can submit my class evaluation.

    As a Teacher
    I want to answer the questionnaire about the class I am enrolled in
    So that I can submit my class evaluation.
    
    Background:test form exists
    Scenario: Teacher tries to submit a form
        Given I am an authenticated Teacher
        And I am on the "Formulários" page
        When I click on a form
        Then I should be on the form page
        And I should be able to answer it
    
    Scenario: Student tries to submit a form    
        Given I am an authenticated Student
        And I am on the "Formulários" page
        When I click on a form
        Then I should be on the form page
        And I should be able to answer it
