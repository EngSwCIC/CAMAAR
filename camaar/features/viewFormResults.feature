# Eu como Administrador
# Quero vizualizar os formulários criados
# A fim de poder gerar um relatório a partir das respostas

Feature: View Form results

    Background:
        Given I'm an Admin
        And I'm on the Management page


    Scenario: View form results 
        When I click on the results Button
        And I click on the Form
        Then I should see the Form results 
        
    Scenario: No one answered the form
        When I click on the results Button
        And I click on the Form
        And There is no answers to the form
        Then I should be prompted with "Não há respostas para esse formulário."
    