Feature: Reply form
    Scenario: Successfully selecting e viewing the form
        Given I am an authenticated user of the system
            And I am seeing the pending forms to fill out

            When I select one form
            And I press "responder"
        
            Then I should see a the questions to answer 
            And I should see a button "enviar"

    Scenario: Successfully filling out and submitting the form
        Given I am an authenticated user of the system
            And I already selected form
            And I already answered all the questions

            When I press "enviar"
        
            Then I should see a success message "formulario enviado com sucesso"
            
    Scenario: Partialy filling out and submitting the form
        Given I am an authenticated user of the system
            And I already selected form
            And I have answered some or none of the questions

            When I press "enviar"
        
            Then I should see a error message "não é possivel enviar formulario incompleto"