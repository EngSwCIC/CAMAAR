Feature: Create forms for teachers and students
    
    As an admin
    I want to select a form for students and teachers
    So that I can assess the class's performance 

    Background:
        Given I am on the Templates page

    Scenario: Form is created
        When I click on the "+" icon
        And I create the questions for the template 
        And I click on "Criar" button
        Then I should see an alert that the template was successfully created

    Scenario: Creating an empty form
        When I click on the "+" icon
        And I click on "Criar" button
        Then I should see an alert that it is not possible to create an empty template created
