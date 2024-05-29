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
        And I should see the generate report Button

    Scenario: 