Feature: Create forms for teachers and students
    
    As an admin
    I want to select a form for students and teachers
    So that I can assess the class's performance 

    Background:
        Given I have clicked on the "Enviar Formulários" button 

    Scenario: Sending a form
        When I select the template that I want to use
        And I select the classes that I want to send the form
        And I click on the "Enviar" button
        Then I should see an alert saying that the form was successfully created

    Scenario: Sending a form without selecting a class
        When I select the template that I want to use
        And I click on the "Enviar" button
        Then I should see an alert saying that it is not possible to send a form without selecting a template
